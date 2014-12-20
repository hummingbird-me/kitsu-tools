class RailsAdminPgArray < RailsAdmin::Config::Fields::Base
  register_instance_option :formatted_value do
    value.join(',') if value
  end
end

class RailsAdminPgStringArray < RailsAdminPgArray
  def parse_input(params)
    if params[name].is_a?(::String)
      params[name] = params[name].split(',')
    end
  end
end

RailsAdmin::Config::Fields::Types::register(:pg_string_array, RailsAdminPgStringArray)
