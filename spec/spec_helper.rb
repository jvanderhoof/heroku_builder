$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start 'rails'

require 'dotenv'
Dotenv.load

require 'heroku_builder'
require 'vcr'
require 'webmock'
require 'pry'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

RSpec.configure do |c|
  #c.after(:all) { VCR.eject_cassette }
end
