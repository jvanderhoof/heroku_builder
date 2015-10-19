require 'spec_helper'

describe HerokuBuilder::EnvVars do
  let(:env_vars) { HerokuBuilder::EnvVars.new }
  let(:name) { 'hound-jason' }

  after do
    VCR.eject_cassette
  end

  describe '.set_config_vars' do
    before do
      VCR.insert_cassette 'set_config_vars_request', record: :new_episodes
    end

    it 'sets heroku config-vars' do
      env_vars.set_config_vars(name, 'FOO': 'bar')
      expect(env_vars.get_config_vars(name)['FOO']).to eq 'bar'
    end
  end

  describe '.get_config_vars' do
    before do
      VCR.insert_cassette 'successful_config_vars_request', record: :new_episodes
    end

    it 'has configuration' do
      result = env_vars.get_config_vars(name)
      expect(result.class).to eq Hash
    end
  end

  describe '.diff_config_vars' do
    it 'shows changes' do
      hsh_1 = { 'Foo': 'bar' }
      hsh_2 = { 'Foo': 'bars' }
      match = "Updating Foo from: 'bar' to: 'bars'"
      expect(env_vars.diff_config_vars(hsh_1, hsh_2).first).to eq match
    end

    it 'shows additions' do
      hsh_1 = { 'Foo': 'bar' }
      hsh_2 = { 'Bar': 'baz' }
      match = "Adding Bar with: 'baz'"
      expect(env_vars.diff_config_vars(hsh_1, hsh_2).first).to eq match
    end
  end

  describe '.config_env_changes' do
    before do
      VCR.insert_cassette 'update_config_vars_request', record: :new_episodes
    end

    it 'shows remote changes' do
      env_vars.set_config_vars(name, 'FOO' => 'baz')
      updates = { 'FOO' => 'yaz' }
      match = "Updating FOO from: 'baz' to: 'yaz'"
      expect(env_vars.config_env_changes(name, updates).first).to eq match
    end
  end
end
