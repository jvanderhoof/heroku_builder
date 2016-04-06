module HerokuBuilder
  class Service
    def self.config_file
      @config_file ||= YAML.load(ERB.new(File.read('config/heroku.yml')).result)
    end

    def self.config_from_environment(environment)
      @config_from_environment ||= config_file[environment]
    end

    def self.update_app(name)
      App.new.find_or_create_app(name)
    end

    def self.run_deployment(name, environment)
      git_branch = config_from_environment(environment)['app']['git_branch']
      Deployment.new.deploy(name, git_branch, environment)
    end

    def self.update_env_vars(name, environment)
      config = config_from_environment(environment)
      return if !config.key?('config_vars') || config['config_vars'].empty?
      EnvVar.new.set_config_vars(name, config['config_vars'])
    end

    def self.update_addons(name, environment)
      config = config_from_environment(environment)
      return if !config.key?('addons') || config['addons'].empty?
      AddOn.new.set_addons(name, config['addons'])
    end

    def self.update_resources(name, environment)
      config = config_from_environment(environment)
      return if !config.key?('resources') || config['resources'].empty?
      Resource.new.set_resources(name, config['resources'])
    end

    def self.deploy(environment)
      name = config_from_environment(environment)['app']['name']
      run_deployment(name, environment)
    end

    def self.configure(environment)
      config = config_from_environment(environment)
      name = config['app']['name']

      update_env_vars(name, environment)
      update_addons(name, environment)
      update_resources(name, environment)
    end

    def self.apply(environment)
      config = config_from_environment(environment)
      name = config['app']['name']

      # find or create app
      update_app(name)

      # set env variables
      update_env_vars(name, environment)

      # find or create addons
      update_addons(name, environment)

      # deploy code
      run_deployment(name, environment)

      # find or create resource
      update_resources(name, environment)
    end
  end
end
