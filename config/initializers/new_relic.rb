GC::Profiler.enable

if defined?(NewRelic) && defined?(Puma)
  NewRelic::Agent.manual_start
  NewRelic::Agent.after_fork force_reconnect: true
end
