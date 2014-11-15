class Rack::Attack
  throttle 'signins/ip', limit: 5, period: 20.seconds do |req|
    if req.path == '/sign-in' && req.post?
      req.ip
    end
  end

  # Long-period throttles allow bursting but not brute force attacks
  # I'm being really generous here, the limits could probably go even lower
  # but what good is a brute-force attack at 1 attempt per 2 minutes?
  throttle 'signins/email', limit: 30, period: 60.minutes do |req|
    if req.path == '/sign-in' && req.post?
      req.params['email'].presence
    end
  end

  throttle 'signups/ip', limit: 20, period: 60.minutes do |req|
    if req.path == '/sign-up' && req.post?
      req.ip
    end
  end

  self.throttled_response = lambda do |env|
    [429, {}, {
      error: "Rate Limit Exceeded"
    }.to_json]
  end
end
