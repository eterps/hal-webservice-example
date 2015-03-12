require 'sinatra/base'
require_relative 'core'
require_relative 'resources'

class Webservice < Sinatra::Base
  get URL.map(:self) do # /
    content_type 'application/hal+json'
    links = {}
    URL.templates.each{|k, v| links[k] = {href: v}}
    {_links: links}.to_json
  end

  get URL.map(:artist) do # /artist/:name
    ArtistResource.new(self).resolve
  end

  get URL.map(:artists) do # /artists
    ArtistsResource.new(self).resolve
  end

  post URL.map(:artists) do # /artists
    ArtistsResource.new(self).resolve
  end
end
