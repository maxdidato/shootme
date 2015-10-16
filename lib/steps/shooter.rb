module Shootme
  class ShooterStep
    def self.create(scenario,config,block)
      shooter = Shootme::Shooter.new(config[:credentials])
      block.call
      root_dir = config[:screenshots_folder]
      Dir.mkdir(root_dir) unless Dir.exists?(root_dir)
      Dir.chdir(root_dir) do
        dir = "#{root_dir}/#{scenario.name}"
        FileUtils.rm_rf(dir) if Dir.exists?(dir)
        Dir.mkdir(dir)
        Dir.chdir(dir) do

          config[:browsers].each do |browser|
            shooter.perform_screenshooting(browser)
          end
        end
      end
    end
  end
end