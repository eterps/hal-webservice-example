require 'addressable/template'
# TODO: give example with URL template at main level. Decorators?? private from_json/to_json

module URL
  def self.templates
    {
      self:    'https://api.artistry.net/',
      artist:  'https://api.artistry.net/artist/{name}',
      artists: 'https://api.artistry.net/artists',
      album:   'https://api.moosicstore.com/album/{name}'
    }
  end

  def self.for(label, params = {})
    template = Addressable::Template.new(templates[label])
    template.expand params
  end

  def self.map(label)
    pattern = templates[label].gsub(/\{([^}]+)\}/, ':\1')
    URI(pattern).path
  end
end

class BaseResource
  attr_reader :webservice
  def initialize(webservice); @webservice = webservice end

  def resolve
    case webservice.request.request_method
    when 'GET'
      headers = {'Content-Type' => 'application/hal+json'}
      status = resource_exists? ? 200 : 404
      body = to_json
    when 'POST'
      resource_exists?
      from_json
      headers = {'Location' => String(create_path)}
      status = 201 if post_is_create?
      body = ''
    end
    [status, headers, body]
  end
end

module DB
  class << self
    attr_accessor :artists

    def artists
      @artists ||= []
    end
  end
end
