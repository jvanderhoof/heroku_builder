require 'heroku_builder'

namespace :builder do
  # Utility functions from development. These may be removed...
  def config_file
    'config/heroku.yml'
  end

  # Rake setup per environment
  if File.exist?(config_file)
    HerokuBuilder::Service.config_file.keys.each do |env|
      namespace env.to_sym do
        task :apply do
          HerokuBuilder::Service.apply(env)
        end

        task :deploy do
          HerokuBuilder::Service.deploy(env)
        end

      end
    end
  end

  desc 'Initial yaml file setup'
  task :init do
    if File.exist?(config_file)
      puts "Heroku Builder configaration file alread exists: `#{config_file}`.  Please remove it if you want to generate a new configaration file."
      exit
    end

    env_config = {
      'app' => {
        'name' => 'my-heroku-app-name',
        'git_branch' =>  'master',
      },
      'config_vars' =>  [
        'BUILDPACK_URL' => 'https://github.com/ddollar/heroku-buildpack-multi.git'
      ],
      'addons' =>  [],
      'resources' =>  {
        'web' =>  {
          'count' =>  1,
          'type' =>  'Free'
        }
      }
    }
    config = {
      'staging' => Marshal.load(Marshal.dump(env_config)),
      'production' => Marshal.load(Marshal.dump(env_config))
    }
    config['staging']['app']['name'] = config['staging']['app']['name']+'-staging'
    config['staging']['app']['git_branch'] = 'staging'

    FileUtils.mkdir_p('config')
    File.open(config_file, 'w') { |f| f.write(config.to_yaml) }
    puts "Heroku Builder configuration file generated in `#{config_file}`"
  end
end
