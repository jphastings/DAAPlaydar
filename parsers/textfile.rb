# The format for these playlists is very simple:
#
#     Playlist Name Here
#     track title,artist name,album name
#     another track from unknown album,another artist
module Playlists
  module Parsers
    # Allows makeing a simple playlist for use
    class Textfile < Parser
      def initialize(textfile)
        begin
          open(textfile) do |f|
            @title = f.readline.rstrip
            @playlist = []
            f.readlines.each do |line|
              data = line.rstrip.split(",")
              @playlist.push({:track => data[0], :artist => data[1], :album => data[2] || ""}) if not data[0].nil? and not data[1].nil?
            end
          end
        rescue Errno::ENOENT
          raise NoSuchPlaylistError, "The file does not exist '#{textfile}'"
        end
      end
      
      def list_playlists
        [{:title => @title, :id => 0}]
      end
      
      def tracks_in_playlist(plid)
        raise NoSuchPlaylistError if plid != 0
        @playlist
      end
      
      FILE_EXTENSIONS = [:txt]
    end
  end
end

