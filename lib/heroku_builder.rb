require 'platform-api'
require 'git'
require 'hashdiff'

require 'heroku_builder/version'
require 'heroku_builder/base'
require 'heroku_builder/service'
require 'heroku_builder/app'
require 'heroku_builder/env_vars'
require 'heroku_builder/add_ons'
require 'heroku_builder/deployment'
require 'heroku_builder/resource'

module HerokuBuilder
  require 'railtie' if defined?(Rails)
end
