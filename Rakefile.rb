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

require "cucumber/rake/task"
Cucumber::Rake::Task.new(:run) do |task|
  task.cucumber_opts = ["features"]
end

require "rdoc/task"
Rake::RDocTask.new do |rdoc| 
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "srs_game"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => ["rdoc"]
