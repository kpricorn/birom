require 'birom/triangle'
require 'birom/turn'
require 'birom/game_player'
require 'birom/counter'
require 'birom/birom'

# TODO: Extract this into it's own birom-motion wrapper gem
if defined?(Motion::Project::Config)
  Motion::Project::App.setup do |app|
    Dir.glob(File.join(File.dirname(__FILE__), 'birom/*.rb')).each do |file|
      app.files.unshift(file)
    end
  end
end
