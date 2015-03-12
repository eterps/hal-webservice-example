Given(/^the client provides the header "(.*)"$/) do |header|
  name, value = header.split(/\s*:\s*/)
  header name, value
end

When(/^the client does a GET request to "(.*)"$/) do |url|
  header 'User-Agent', 'curl'
  get URI(url).path
end

When(/^the client does a POST request to "(.*)" with the following data:$/) do |path, data|
  header 'User-Agent', 'curl'
  post path, data
end

Then(/^the response should be HAL JSON:$/) do |json|
  File.open('/tmp/json', 'w'){|f| f.puts JSON.pretty_unparse(JSON.parse(last_response.body))}
  last_response.headers['Content-Type'].should eq('application/hal+json')
  last_response.body.should be_json_eql(json)
end

Then(/^the (.*) header should be "(.*)"$/) do |name, value|
  last_response.headers[name].should == value
end

Then(/^the status code should be "(\d+)"/) do |status_code|
  STDERR.puts last_response.body if last_response.status != status_code.to_i
  last_response.status.should == status_code.to_i
end
