module Shootme
  class ShooterStep
    def self.create(scenario, config, block)
      shooter = Shootme::Shooter.new(config[:credentials])
      block.call
      dir = FileUtils.mkdir_p("#{config[:screenshots_folder]}/#{scenario.name}")[0]
      Dir.chdir(dir) do
        config[:browsers].each do |browser|
          shooter.perform_screenshooting(browser)
        end
      end
    end
  end
end