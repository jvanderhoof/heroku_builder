require 'heroku_builder'
require 'rails'

module HerokuBuilder
  class Railtie < Rails::Railtie
    rake_tasks do
      spec = Gem::Specification.find_by_name 'heroku_builder'
      load "#{spec.gem_dir}/lib/tasks/heroku_builder.rake"
    end
  end
end
