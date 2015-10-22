module Shootme
  class MultibrowserStep
    def self.create(scenario, config, project_dir, block)

      config[:browsers].each do |browser_setting|
        begin
          driver_name= Shootme::Adapter.current_adapter.set_driver(browser_setting, config[:credentials])
          Capybara.reset_sessions!
          #TODO:Test this against all the possible NON test steps
          feature_file = create_feature_file(browser_setting, project_dir, scenario_text(scenario))
          driver_file = create_driver_file(driver_name, project_dir)
          failed = execute_cucumber_test(feature_file)
        ensure
          feature_file.unlink if feature_file
          driver_file.unlink if driver_file
        end
      end
      scenario.fail if failed
    end

    def self.execute_cucumber_test(feature_file)
      begin
        Cucumber::Cli::Main.execute([feature_file.path, '-r', 'features'])
        return false
      rescue SystemExit => e
        return e.status!=0
      rescue Exception
        return true
      end
    end

    def self.scenario_text(scenario)
      filtered_steps = scenario.test_steps.select { |el| el.source.last.is_a?(Cucumber::Core::Ast::Step) }
      filtered_steps.map { |step| step.source.last.keyword+step.source.last.name }.inject("") { |str, step| str = str+step+"\n" }
    end

    def self.create_driver_file(driver_name, project_dir)
      file = Tempfile.new(['hello', '.rb'], "#{project_dir}/features/support")
      file.write("Capybara.current_driver=:#{driver_name}")
      file.close
      file
    end

    def self.create_feature_file(browser_setting, project_dir, text)
      file = Tempfile.new(['hello', '.feature'], "#{project_dir}/features")
      file.write("Feature: #{browser_setting[:browser]} #{browser_setting[:browser_version]}\n Scenario: Perform\n"+text)
      file.close
      file
    end
  end
end