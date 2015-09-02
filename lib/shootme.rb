require "shootme/version"
require "shootme/shooter"
module Shootme
  def self.included(base)
    proc=Proc.new do |scenario, block|
      block.call
      config= YAML.load_file("/Users/mdidato/Projects/Personal/shootme/.shootme.yml")
      root_dir = config[:screenshots_folder]
      Dir.mkdir(root_dir) unless Dir.exists?(root_dir)
      Dir.chdir(root_dir) do
        dir = "#{root_dir}/#{scenario.name}"
        FileUtils.rm_rf(dir) if Dir.exists?(dir)
        Dir.mkdir(dir)
        Dir.chdir(dir) do

          shooter = Shootme::Shooter.new(config[:credentials])
          config[:browsers].each do |browser|
            shooter.perform_screenshooting(browser)
          end
        end
      end
    end
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@screenshot"], proc)
  end
end
