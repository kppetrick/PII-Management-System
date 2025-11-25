class Rack::Attack

    Rack::Attack.cache.store = Rails.cache

    throttle('api/post', limit: 10, period: 1.minute) do |req|
        req.ip if req.path.start_with?('/api') && req.post?
    end

    throttle('api/get', limit: 60, period: 1.minute) do |req|
        req.ip if req.path.start_with?('/api') && req.get?
    end

    throttle('api/ip', limit: 100, period: 1.minute) do |req|
        req.ip if req.path.start_with?('/api')
    end

    self.throttled_response = lambda do |env|
        match_data = env['rack.attack.match_data']
        now = match_data[:epoch_time]
        
        headers = {
            'X-RateLimit-Limit' => match_data[:limit].to_s,
            'X-RateLimit-Remaining' => '0',
            'X-RateLimit-Reset' => (now + (match_data[:period] - (now % match_data[:period]))).to_s,
            'Content-Type' => 'application/json'
        }
        
        body = {
            error: 'Rate limit exceeded. Please try again later.',
            retry_after: match_data[:period] - (now % match_data[:period])
        }.to_json
        
        [429, headers, [body]]
    end
end