require "shootme/version"
require 'shootme/server'
require "shootme/drivers"
require 'shootme/adapter'
require "shootme/shooter"
require 'shootme/steps'
require 'cucumber'

module Shootme
  def self.included(_)
    project_dir = get_project_dir
    shooter_step=Proc.new do |scenario, block|
      config= YAML.load_file("#{project_dir}/.shootme.yml")
      Shootme::ShooterStep.create(scenario, config, block)
    end
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@screenshot"], shooter_step)

    multibrowser_step = Proc.new do |scenario, block|
      config= YAML.load_file("#{project_dir}/.shootme.yml")
      Shootme::MultibrowserStep.create(scenario, config, project_dir, block)
    end
    Cucumber::RbSupport::RbDsl.register_rb_hook('around', ["@multibrowser"], multibrowser_step)

  end

  private
  def self.get_project_dir
    Pathname.new(caller.map { |el| el.split(':') }.find { |el| el[2]=="in `include'" }[0]).parent.parent.parent
  end
end
