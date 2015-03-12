require 'json_spec/cucumber'

def last_json
  last_response.body
end

JsonSpec.configure do
  exclude_keys 'date', 'time', 'queried_at'
end
