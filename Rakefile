require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "DAAPlaydar"
    gem.summary = %Q{Make resolvable playlists visible in DAAP Clients (like iTunes and songbird) via the power of playdar}
    gem.description = %Q{Make resolvable playlists visible in DAAP Clients (like iTunes and songbird) via the power of playdar}
    gem.email = "jphastings@gmail.com"
    gem.homepage = "http://github.com/jphastings/DAAPlaydar"
    gem.authors = ["JP Hastings-Spital"]
    gem.add_dependencies ["dmap", "PlaydARR","xspf","dnssd","sinatra"] # probably more
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "iTunes-playdar #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
