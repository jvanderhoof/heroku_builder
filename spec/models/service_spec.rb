require 'spec_helper'

describe HerokuBuilder::Service do
  def check_deploy
    allow_any_instance_of(HerokuBuilder::Deployment).to receive(:deploy)
  end

  subject { described_class }
  before do
    allow(subject).to receive(:config_file).and_return('bar' => {
      'config_vars' => [
        'baz' => '1'
      ],
      'app' => { 'git_branch' => 'foo' },
      'addons' => ['foo'],
      'resources' => { 'foo' => 'bar' }
    })
  end

  describe '#update_addons' do
    it 'updates' do
      allow_any_instance_of(HerokuBuilder::AddOn).to receive(:set_addons)
      subject.update_addons('foo', 'bar')
    end
  end

  describe '#update_resources' do
    it 'updates' do
      allow_any_instance_of(HerokuBuilder::Resource).to receive(:set_resources)
      subject.update_resources('foo', 'bar')
    end
  end

  describe '#deploy' do
    it 'deploys' do
      check_deploy
      subject.deploy('foo')
    end
  end

  describe '#run_deployment' do
    it 'deploys' do
      check_deploy
      subject.run_deployment('foo', 'bar')
    end
  end

  describe '#update_env_vars' do
    it 'updates the env vars' do
      allow_any_instance_of(HerokuBuilder::EnvVar).to receive(:set_config_vars)
      subject.update_env_vars('foo', 'bar')
    end
  end

  describe '#update_app' do
    it 'updates the app' do
      allow_any_instance_of(HerokuBuilder::App).to receive(:find_or_create_app).and_return 'foo'
      subject.update_app('foo')
    end
  end

  describe '#apply' do
    it 'runs all the tasks' do
      allow_any_instance_of(HerokuBuilder::App).to receive(:find_or_create_app)
      allow_any_instance_of(HerokuBuilder::EnvVar).to receive(:set_config_vars)
      check_deploy
      allow_any_instance_of(HerokuBuilder::AddOn).to receive(:set_addons)
      allow_any_instance_of(HerokuBuilder::Resource).to receive(:set_resources)
      subject.apply('foo')
    end
  end
end
