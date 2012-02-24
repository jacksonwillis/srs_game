################
# Bundler      #
################

require "bundler"

desc "Setup bundler"
task :bundle do
  begin
    Bundler.setup(:default)
  rescue Bundler::BundlerError => e
    $stderr.puts e.message
    $stderr.puts "Run `bundle install` to install missing gems"
    exit e.status_code
  end
end

################
# Cucumber     #
################

require "cucumber/rake/task"

namespace :cuke do
  Cucumber::Rake::Task.new(:run) do |task|
    task.cucumber_opts = ["-t", "@#{ENV["TAG"] || "all" }", "features"]
  end
end

################
# RDoc         #
################

require "rdoc/task"

rdoc_options = {
  :rdoc  => "rdoc",
  :clobber_rdoc => "rdoc:clean",
  :rerdoc => "rdoc:force"
}

RDoc::Task.new(rdoc_options) do |rdoc| 
    rdoc.rdoc_dir = "doc"
    rdoc.title = "srs_game"
    rdoc.main = "README.rdoc"
    rdoc.rdoc_files.include("README*")
    rdoc.rdoc_files.include("lib/**/*.rb")
end

################
# Play         #
################

$LOAD_PATH << File.expand_path("lib")
require "srs_game"
include SRSGame

namespace :play do
  desc "Play as a follower of the Cult of Tia"
  task :tia do
    require "srs_game/tia"
    SRSGame.play Tia, ENV
  end

  desc "Play as the goddess Tamera"
  task :tamera do
    require "srs_game/tamera"
    SRSGame.play Tamera, ENV
  end
end

################
# Default      #
################

task :default => ["bundle", "cuke:run", "rdoc:force"]
