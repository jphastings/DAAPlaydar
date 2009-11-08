require 'digest/sha1'

module Playlists
  module Parsers
    # Looks for playlist descriptors locally
    class Local < Parser
      @@extensions = nil
            
      def initialize(location)
        raise "Directory does not exist" if not File.directory?(location)
        @location = location
        @playlists = {}
      end

      def list_playlists
        # Get a list of acceptable file extensions
        find_extensions if @@extensions.nil?
        playlists = []
        # Scan the directory
        Dir.glob(File.join(@location,"*.{#{@@extensions.keys.join(',')}}")) do |playlist_uri|
          begin
            parser = @@extensions[File.extname(playlist_uri)[1..-1].to_sym].new(playlist_uri)
          rescue NoSuchPlaylistError
            raise NoSuchPlaylistError "Local #{$!.to_s}"
          end
          parser.list_playlists.each do |playlist|
            uuid = Digest::SHA1.hexdigest(playlist_uri)
            @playlists[uuid] = {:parser => parser, :local_id => playlist[:id]}
            playlists.push({:id => uuid, :title => playlist[:title]})
          end
        end
        playlists
      end

      def tracks_in_playlist(plid)
        raise NoSuchPlaylistError if not @playlists.has_key?(plid)
        @playlists[plid][:parser].tracks_in_playlist(@playlists[plid][:local_id])
      end

      def find_extensions
        @@extensions = {}
        # Iterate through classes in the Playlist module
        Playlists::Parsers.constants.each do |parser|
          begin
            Playlists.class_eval(parser)::FILE_EXTENSIONS.each do |ext|
              @@extensions[ext] = Playlists.class_eval(parser)
            end
          rescue NameError
            # This parser doesn't support local files
          end
        end
        @@extensions
      end
    end
  end
end