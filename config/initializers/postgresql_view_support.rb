ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
    def table_exists?(name)
      return true if super
      name = name.to_s
      schema, table = name.split('.', 2)

      unless table # A table was provided without a schema
        table = schema
        schema = nil
      end

      if name =~ /^"/ # handle quoted table names
        table = name
        schema = nil
      end

      query(<<-SQL).first[0].to_i > 0
        SELECT COUNT(*) FROM pg_views
        WHERE viewname = '#{table.gsub(/(^"|"$)/, '')}'
        #{schema ? "AND schemaname = '#{schema}'" : ''}
      SQL
    end
  end
end
