Given(/^these albums:$/) do |table|
  table.hashes.each do |row|
    artist_name = row.delete('artist')
    album_name  = row.delete('album')

    artist = DB.artists.find{|n| n.name == artist_name}
    DB.artists << artist = Artist.new(name: artist_name) if artist.nil?

    artist.albums ||= []
    album = artist.albums.find{|n| n.name == album_name}
    artist.albums << Album.new(name: album_name) if album.nil?
  end
end

Then(/^this artist should exist:$/) do |table|
  table.hashes.each do |row|
    name = row.delete('name')

    DB.artists.find{|n| n.name == name}.should_not be_nil
  end
end
