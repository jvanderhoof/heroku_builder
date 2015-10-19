require 'spec_helper'

def wrap_env(envs = {})
  original_envs = ENV.select { |k, _| envs.key? k }
  envs.each { |k, v| ENV[k] = v }

  yield
ensure
  envs.each { |k, _| ENV.delete k }
  original_envs.each { |k, v| ENV[k] = v }
end

describe HerokuBuilder::Base do
  let(:base_obj) { HerokuBuilder::Base.new }
  describe '.conn' do
    it 'responds with an exception if API key is not present' do
      wrap_env('HEROKU_API_KEY' => nil) do
        expect { base_obj.conn }.to raise_error RuntimeError
      end
    end
  end
end
