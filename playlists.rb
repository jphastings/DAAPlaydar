require 'rubygems'
require 'yaml'
require 'uuid'
require 'digest/sha1'

module Playlists
  @@sources = nil
  @@playlists = {}
  
  module Parsers
    # The Prototype
    class Parser
      def initialize(init_var); end
      def list_playlists; []; end
      def tracks_in_playlist(plid); []; end
    end
    
    # Load all the parsers TODO: Error catching
    Dir.glob(File.join("parsers","*.rb")) do |parser_rb|
      require parser_rb
    end
  end
  
  class NoSuchPlaylistError < RuntimeError; end
  
  # A helper class for the end user
  class Playlist
    attr_reader :title,:plid
    def initialize(id,title,source)
      @title = title
      @plid = id
      @parser = source
    end
    
    def tracks
      @parser.tracks_in_playlist(@plid)
    end
    
    def inspect
      "Playlist: #{@title}"
    end
  end
  
  # This may well take some time to do, should the result be cached?
  def self.list
    self.find_sources if @@sources.nil?
    @@sources.collect do |parser|
      parser.list_playlists.collect do |playlist| 
        Playlist.new(playlist[:id],playlist[:title],parser)
      end
    end.flatten
  end
  
  def self.find_sources
    # Reset the sources array
    @@sources = []
    # Go through each source and list the names of the playlists they offer
    YAML.load(open("sources.yaml")).each_pair do |parser,specs|
      specs.each do |spec|
        begin
          @@sources.push self::Parsers.class_eval(parser).send(:new,spec)
        rescue
          warn("#{parser} playlist not loaded\n  exception: #{$!.class}\n  description: #{$!.to_s}\n  specification used: #{spec.to_s}")
        end
      end
    end
  end
end