# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null
#  external_id   :string           not null
#  media_id      :integer          not null
#  media_type    :string           not null
#

class Mapping < ActiveRecord::Base
  belongs_to :media, polymorphic: true, required: true

  validates :external_site, :external_id, presence: true
  # Right now, we want to ensure only one external id per media per site
  validates :media_id, uniqueness: { scope: %i[media_type external_site] }

  def self.lookup(site, id)
    find_by(external_site: site, external_id: id).try(:media)
  end

  def self.guess(type, info)
    results = "MediaIndex::#{type}".constantize.query(
      function_score: {
        field_value_factor: {
          field: 'user_count',
          modifier: 'log1p'
        },
        query: {
          bool: {
            should: [
              { multi_match: {
                fields: %w[titles.* abbreviated_titles],
                query: info[:title],
                fuzziness: 3,
                max_expansions: 15,
                prefix_length: 2
              } },
              ({ match: {
                show_type: info[:show_type]
              } } if info[:show_type].present?),
              ({ match: {
                manga_type: info[:manga_type]
              } } if info[:manga_type].present?),
              ({ fuzzy: {
                episode_count: {
                  value: info[:episode_count],
                  fuzziness: 2
                }
              } } if info[:episode_count].present?),
              ({ fuzzy: {
                episode_count: {
                  value: info[:chapter_count],
                  fuzziness: 2
                }
              } } if info[:chapter_count].present?)
            ].compact
          }
        }
      }
    )
    top_result = results.preload.first
    # If we only get one result, or the top result has a good score, pick it
    top_result if top_result && top_result._score > 5 || results.count == 1
    # Otherwise nil
  end
end
