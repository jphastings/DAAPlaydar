module Playlists
  module Parsers
    # Fakes a playlist, for debug
    class Faker < Parser
      def initialize(void);end
      def list_playlists; [{:title => 'Groovy Playlist', :id => 0}]; end
      def tracks_in_playlist(plid)
        raise NoSuchPlaylistError if plid != 0
        [
          {
            :artist => "Calvin Harris",
            :track  => "The Rain",
            :album  => "Ready for the Weekend"
          }
        ]
      end
    end
  end
end