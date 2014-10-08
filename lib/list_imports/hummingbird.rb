class HummingbirdListImport
  include Enumerable

  STATUS_MAP = {
    'currently_watching' => 'Currently Watching',
    'currently_reading' => 'Currently Reading',
    'plan_to_watch' => 'Plan to Watch',
    'plan_to_read' => 'Plan to Read',
    'completed' => 'Completed',
    'on_hold' => 'On Hold',
    'dropped' => 'Dropped'
  }
    

  # Most ListImport systems shouldn't need a `list` parameter, since they separate manga and anime
  # exports.  We do, since our backups contain your whole library.
  def initialize(str, list)
    @list = ActiveSupport::JSON.decode(str)[list.to_s]
    # The class of the database we're matching against
    @db = list.to_s.camelize.constantize
    @media_type = list.to_sym
  end

  # Enumerate all the rows in the list
  def each
    @list.each do |row|
      exact_keys = %w{episodes_watched rewatch_count rewatching notes private rating
                      chapters_read volumes_read reread_count rereading}
      hash = row.slice(*exact_keys).symbolize_keys

      hash[:last_watched] = Time.parse(row['last_watched']) if hash[:last_watched]
      hash[:last_read] = Time.parse(row['last_read']) if hash[:last_read]
      hash[:status] = STATUS_MAP[row['status']]

      # If this weren't our own backup, we'd want to use a fuzzy match instead
      hash[:media] = @db.find(row[@media_type.to_s]['id'])
      yield hash
    end
  end

  def media_type
    @media_type
  end
end
