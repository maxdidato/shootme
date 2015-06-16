require "shootme/version"

module Shootme
  def self.included(base)
proc=Proc.new do |scenario,block|
  block.call
  root_dir = "/Users/mdidato/snapshots"
  Dir.mkdir(root_dir) unless Dir.exists?(root_dir)
  Dir.chdir(root_dir) do
    dir = "#{root_dir}/#{scenario.name}"
    FileUtils.rm_rf(dir)if Dir.exists?(dir)
    Dir.mkdir(dir)
    Dir.chdir(dir) do
      Shootme::Shooter.credentials username: 'massimiliano8', password: 'scQH4sZwU3TYhWygmvpp'
      Shootme::Shooter.new().perform_screenshooting browser: 'IE', browser_version: '7.0', os: 'Windows', os_version: 'XP'

      # Shootme::Shooter.new().perform_screenshooting browser: 'IE', browser_version: '6.0', os: 'Windows', os_version: 'XP'
    end


  end
end
Cucumber::RbSupport::RbDsl.register_rb_hook('around',["@screenshot"],proc)
  end
end
