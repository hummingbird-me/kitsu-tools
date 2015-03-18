class CreateTrendingGroupsViews < ActiveRecord::Migration
  def up
    # This hefty SQL view takes the group_members and groups by (group.id,
    # created_at), infilling with zeroes for dead times since the founding of
    # the group
    execute(<<-SQL)
CREATE OR REPLACE VIEW group_members_histogram AS
SELECT coalesce(counts.cnt, 0) AS cnt, fills.*
FROM ( -- Buckets infilled with zeroes
  SELECT *
  FROM ( -- All possible (group_id, created_at) tuples
    SELECT groups.id AS group_id, groups.created_at AS founded, generate_series AS created_at
    FROM groups
    -- floor(now) - 30.days ... ceil(now) with 1-hour intervals
    CROSS JOIN generate_series(date_trunc('hour', timezone('utc', now())) - interval '30 days', timezone('utc', now()) + interval '1 hour', '1 hour')
  ) AS buckets
  WHERE buckets.created_at >= date_trunc('hour', buckets.founded)
) AS fills
LEFT OUTER JOIN (
  SELECT count(*) AS cnt, group_id, date_trunc('hour', created_at) AS created_at
  FROM group_members
  WHERE created_at > (now() - interval '30 days')
  GROUP BY group_id, date_trunc('hour', created_at)
) AS counts
ON counts.created_at = fills.created_at
AND counts.group_id = fills.group_id
    SQL

    # This even heftier SQL view takes the bucketed group_members_histogram and
    # generates average and sum for two periods (7-day and 6-hour) and the
    # deviation.  From this it calculates the z-score.
    # This view is _materialized_ and refreshed every 5 minutes
    execute(<<-SQL)
CREATE MATERIALIZED VIEW trending_groups AS
SELECT
  groups.id AS group_id,
  short_avg AS short_avg,
  short_sum AS short_sum,
  long_avg AS long_avg,
  long_sum AS long_sum,
  deviation AS deviation,
  trending.score AS score
FROM groups
JOIN (
  SELECT
    long_term.group_id AS group_id,
    short_term.avg AS short_avg,
    short_term.sum AS short_sum,
    long_term.avg AS long_avg,
    long_term.sum AS long_sum,
    long_term.dev AS deviation,
    -- The weird addition here is a silly hack to prevent division by zero
    (short_term.avg - long_term.avg) / (long_term.dev + 0.0000000001) AS score
  FROM ( -- Get the sum, deviation, and average for the hourly data of the past 7 days
    SELECT group_id, count(cnt) AS cnt, sum(cnt) AS sum, stddev_pop(cnt) AS dev, avg(cnt) AS avg
    FROM group_members_histogram
    WHERE created_at >= (date_trunc('hour', now()) - interval '7 days')
    -- This is to prevent groups from showing up until there's reasonable data
    AND founded < (date_trunc('hour', now()) - interval '6 hours')
    GROUP BY group_id
  ) AS long_term
  JOIN ( -- Get the sum and average for the hourly data of the past 6 hours
    SELECT group_id, count(cnt) AS cnt, sum(cnt) AS sum, avg(cnt) AS avg
    FROM group_members_histogram
    WHERE created_at >= (date_trunc('hour', now()) - interval '6 hours')
    -- This is to prevent groups from showing up until there's reasonable data
    AND founded < (date_trunc('hour', now()) - interval '6 hours')
    GROUP BY group_id
  ) AS short_term
  ON short_term.group_id = long_term.group_id
) AS trending
ON trending.group_id = groups.id
WHERE trending.score IS NOT NULL
AND groups.confirmed_members_count > 5
ORDER BY trending.score DESC
    SQL
  end
  def down
    execute 'DROP MATERIALIZED VIEW trending_groups'
    execute 'DROP VIEW group_members_histogram'
  end
end
