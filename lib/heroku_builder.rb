require 'platform-api'
require 'git'
require 'hashdiff'
require 'logger'
require 'yaml'
require 'erb'

require 'heroku_builder/version'
require 'heroku_builder/base'
require 'heroku_builder/service'
require 'heroku_builder/app'
require 'heroku_builder/env_var'
require 'heroku_builder/add_on'
require 'heroku_builder/deployment'
require 'heroku_builder/resource'

module HerokuBuilder
  require 'railtie' if defined?(Rails)
end
