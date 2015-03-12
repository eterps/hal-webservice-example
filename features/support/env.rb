require 'rack/test'
require_relative '../../webservice'

module AppHelper
  def app
    Webservice
  end
end

World Rack::Test::Methods, AppHelper
