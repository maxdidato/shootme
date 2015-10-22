module Shootme
  class MultibrowserStep
    def self.create(scenario,config,project_dir,block)

      config[:browsers].each do |browser_setting|
        driver_name= Shootme::Adapter.current_adapter.set_driver(browser_setting,config[:credentials])
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
end