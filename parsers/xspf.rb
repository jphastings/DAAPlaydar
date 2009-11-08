require 'open-uri'
require 'hpricot'

module Playlists
  module Parsers
    # Parses XSPF playlists
    class XSPF < Parser
      # NB. This uri can be local or remote
      def initialize(uri)
        begin
          @xspf = Hpricot(open(uri))
        rescue SocketError, Errno::ENOENT
          raise NoSuchPlaylistError, "The URI '#{uri}' does not point to a valid XSPF playlist."
        end
      end
  
      def list_playlists
        [{:title => (@xspf/:playlist/:title)[0].inner_text, :id=>0}] # Multiple playlists?
      end
  
      def tracks_in_playlist(plid)
        raise NoSuchPlaylistError if plid != 0
        (@xspf/:playlist/:tracklist/:track).collect do |track|
          album = (track/:album)[0].inner_text rescue ""
          {:track => (track/:title)[0].inner_text, :artist => (track/:creator)[0].inner_text, :album => album}
        end
      end
  
      FILE_EXTENSIONS = [:xspf]
    end
  end
end