if defined?(Motion::Project::Config)
  Motion::Project::App.setup do |app|
    dir = File.dirname(__FILE__)
    Dir.glob(File.join(dir, 'motion_flux/*.rb')).each do |file|
      app.files.unshift(file)
    end
  end
else
  require 'motion_flux/version'
  require 'motion_flux/action'
  require 'motion_flux/dispatcher'
  require 'motion_flux/store'
end
