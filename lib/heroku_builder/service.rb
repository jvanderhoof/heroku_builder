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

    def self.update_env_vars(name, environment)
      env_vars = config_from_environment(environment)['config_vars']
      EnvVars.new.set_config_vars(name, env_vars)
    end

    def self.run_deployment(name, environment)
      git_branch = config_from_environment(environment)['app']['git_branch']
      Deployment.new.deploy(name, git_branch, environment)
    end

    def self.update_addons(name, environment)
      addons = config_from_environment(environment)['addons']
      AddOns.new.set_addons(name, addons)
    end

    def self.update_resources(name, environment)
      resources = config_from_environment(environment)['resources']
      Resource.new.set_resources(name, resources)
    end

    def self.process(environment)
      config = config_from_environment(environment)
      name = config['app']['name']

      # find or create app
      update_app(name)

      # set env variables
      update_env_vars(name, environment)

      # deploy code
      # run_deployment(name, environment)

      # find or create addons
      update_addons(name, environment)

      # find or create resource
      update_resources(name, environment)
    end
  end
end
