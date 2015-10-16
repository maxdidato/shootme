require "shootme/version"
require "shootme/shooter"
require 'cucumber'

module Shootme
  def self.included(base)

    shooter_step=Proc.new do |scenario, block|
      project_dir =Pathname.new(caller.map { |el| el.split(':') }.find { |el| el[2]=="in `include'" }[0]).parent.parent.parent
      config= YAML.load_file("#{project_dir}/.shootme.yml")
      Shootme::ShooterStep.create(scenario,config,block)
    end
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@screenshot"], shooter_step)

    multibrowser_step = Proc.new do |scenario, block|
      project_dir =Pathname.new(caller.map{ |el| el.split(':') }.find { |el| el[2]=="in `include'" }[0]).parent.parent.parent
      config= YAML.load_file("#{project_dir}/.shootme.yml")
      Shootme::MultibrowserStep.create(scenario,config,project_dir,block)
    end
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@multibrowser"], multibrowser_step)

  end


  class MultibrowserStep
    def self.create(scenario,config,project_dir,block)

      config[:browsers].each do |browser_setting|
        driver_name= shooter.set_driver(browser_setting)
        Capybara.reset_sessions!
        #TODO:Test this against all the possible NON test steps
        filtered_steps = scenario.test_steps.select { |el| el.source.last.is_a?(Cucumber::Core::Ast::Step) }
        text = filtered_steps.map { |step| step.source.last.keyword+step.source.last.name }.inject("") { |str, step| str = str+step+"\n" }
        file = Tempfile.new(['hello', '.feature'], "#{project_dir}/features")
        file.write("Feature: #{browser_setting[:browser]} #{browser_setting[:browser_version]}\n Scenario: Perform\n"+text)
        file.close
        file2 = Tempfile.new(['hello', '.rb'], "#{project_dir}/features/support")
        file2.write("Capybara.current_driver=:#{driver_name}")
        file2.close
        begin
          Cucumber::Cli::Main.execute([file.path, '-r', 'features'])
        rescue SystemExit => e
          @failed = e.status!=0
        rescue Exception
          @failed=true
        end
        file.unlink
        file2.unlink
      end
      scenario.fail if @failed
    end
  end

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
