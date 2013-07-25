GC::Profiler.enable

if Rails.env.production?
  NewRelic::Agent.manual_start
  NewRelic::Agent.after_fork force_reconnect: true
end
