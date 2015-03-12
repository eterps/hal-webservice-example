require 'roar/json/hal'

class Artist
  attr_accessor :name, :albums

  def initialize(name: name, albums: albums)
    @name, @albums = name, albums
  end
end

class Album
  attr_accessor :name

  def initialize(name: name)
    @name = name
  end
end

module ArtistRepresenter
  include Roar::JSON::HAL

  link(:self){ URL.for :artist, name: name }
  links(:albums) do
    albums.map{|n| {href: URL.for(:album, name: n.name)}}
  end

  property :name
end

module ArtistsRepresenter
  include Roar::JSON::HAL

  link(:self){ URL.for :artists }
  links(:artists) do
    @artists.map{|n| {href: URL.for(:artist, name: n.name)}}
  end
end

class ArtistResource < BaseResource
  def resource_exists?
    @artist = DB.artists.find{|n| n.name == webservice.params[:name]}
  end

  def from_json
    @artist = Artist.new(albums: [])
    @artist.extend(ArtistRepresenter).from_json(webservice.request.body.read)
  end

  def to_json
    @artist.extend(ArtistRepresenter).to_json
  end
end

class ArtistsResource < BaseResource
  def resource_exists?
    @artists = DB.artists
  end

  def allowed_methods; %w(GET POST) end
  def post_is_create?; true end
  def create_path; URL.for(:artist, name: @artists.last.name) end

  def from_json
    artist = Artist.new
    artist.extend(ArtistRepresenter).from_json(webservice.request.body.read)
    @artists << artist
  end

  def to_json
    extend(ArtistsRepresenter).to_json
  end
end
