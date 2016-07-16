# NOTE: only doing this in development as production environments are generally
# read-only. And besides — it's just not proper to have a dev-mode tool do its
# thing in production.
if Rails.env.development?
  task :set_annotation_options do
    # You can override any of these by setting an environment variable of the
    # same name.
    Annotate.set_defaults(
      'classified_sort'         => 'true',
      'exclude_controllers'     => 'true',
      'force'                   => 'false',
      'format_bare'             => 'true',
      'hide_limit_column_types' => 'integer,boolean',
      'routes'                  => 'true',
      'show_foreign_keys'       => 'true',
      'show_indexes'            => 'true',
      'simple_indexes'          => 'true',
      'wrapper'                 => 'true',
      'wrapper_open'            => 'rubocop:disable Metrics/LineLength',
      'wrapper_close'           => 'rubocop:enable Metrics/LineLength'
    )
  end

  Annotate.load_tasks
end
