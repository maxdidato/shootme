require "shootme/version"
require "shootme/shooter"
module Shootme
  def self.included(base)
    project_dir =Pathname.new(caller.map { |el| el.split(':') }.find { |el| el[2]=="in `include'" }[0]).parent.parent.parent
    config= YAML.load_file("#{project_dir}/.shootme.yml")
    shooter = Shootme::Shooter.new(config[:credentials])
    proc=Proc.new do |scenario, block|
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
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@screenshot"], proc)

    second_proc = Proc.new do |scenario, block|
      config[:browsers].each do |browser_setting|
        driver_name= shooter.set_driver(browser_setting)
        Capybara.reset_sessions!
        text = scenario.test_steps.map { |step| step.source.last.keyword+step.source.last.name }.inject("") { |str, step| str = str+step+"\n" }
        file = Tempfile.new(['hello', '.feature'], "#{project_dir}/features")
        file.write("Feature: #{browser_setting[:browser]} #{browser_setting[:browser_version]}\n Scenario: Perform\n"+text)
        file.close
        file2 = Tempfile.new(['hello', '.rb'], "#{project_dir}/features/support")
        file2.write("Capybara.current_driver=:#{driver_name}")
        file2.close
        lambda { Cucumber::Cli::Main.execute([file.path, '-r', 'features']) }
        # puts  `cucumber --require features #{file.path}`
        # Cucumber::Runtime.new(configuration([file.path, '-r', 'features'])).run!
        file.unlink
        file2.unlink
        #

        #     block.call
      end
    end
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@multibrowser"], second_proc)

  end

end
