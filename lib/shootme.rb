require "shootme/version"
require "shootme/shooter"
module Shootme
  def self.included(base)
proc=Proc.new do |scenario,block|
  block.call
  root_dir =  File.expand_path('../', __FILE__)
  Dir.mkdir(root_dir) unless Dir.exists?(root_dir)
  Dir.chdir(root_dir) do
    dir = "#{root_dir}/#{scenario.name}"
    FileUtils.rm_rf(dir)if Dir.exists?(dir)
    Dir.mkdir(dir)
    Dir.chdir(dir) do
      shooter = Shootme::Shooter.new( username: 'massimiliano8', password: 'scQH4sZwU3TYhWygmvpp')
      shooter.perform_screenshooting(YAML.load_file("/Users/mdidato/Projects/Personal/shootme/.shootme.yml")['browsers'][0])
      # Shootme::Shooter.new().perform_screenshooting browser: 'IE', browser_version: '6.0', os: 'Windows', os_version: 'XP'
    end


  end
end
Cucumber::RbSupport::RbDsl.register_rb_hook('around',["@screenshot"],proc)
  end
end
