require 'spec_helper'

describe HerokuBuilder::App do
  let(:app) { HerokuBuilder::App.new }
  let(:existing_app_name) { 'hound-jason' }

  after do
    VCR.eject_cassette
  end


  describe '.app_exists?' do
    before do
      VCR.insert_cassette 'existing_app_request', record: :new_episodes
    end
    describe 'when app exists' do
      it 'returns true' do
        expect(app.app_exists?(existing_app_name)).to eq true
      end
    end
    describe 'when app does not exists' do
      it 'returns false' do
        expect(app.app_exists?('foo-bar')).to eq false
      end
    end
  end

  describe '.app' do
    describe 'app exists' do
      before do
        VCR.insert_cassette 'existing_app_request', record: :new_episodes
      end
      it 'returns app hash' do
        expect(app.app(existing_app_name)['name']).to eq existing_app_name
      end
    end
    describe 'app does not exist' do
      before do
        VCR.insert_cassette 'non_existing_app_request', record: :new_episodes
      end
      it 'returns app hash' do
        expect(app.app('foo-bar')).to eq({})
      end
    end
  end

  describe '.find_or_create_app' do
    describe 'existing app' do
      before do
        VCR.insert_cassette 'existing_app_request', record: :new_episodes
      end
      it 'responds with app' do
        expect(app.find_or_create_app(existing_app_name)['name']).to eql existing_app_name
      end
    end
    describe 'new app' do
      before do
        VCR.insert_cassette 'new_app_request', record: :new_episodes
      end
      it 'responds with app' do
        app_name = 'testing-foo-bar'
        response_app = app.find_or_create_app(app_name)
        expect(response_app['name']).to eq app_name
        expect(response_app['stack']['name']).to eq 'cedar-14'
        expect(response_app['dynos'].to_i).to eq 0
      end
    end
  end


end
