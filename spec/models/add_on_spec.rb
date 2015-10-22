require 'spec_helper'

describe HerokuBuilder::AddOn do
  let(:add_on) { HerokuBuilder::AddOn.new }
  let(:name) { 'hound-jason' }

  after do
    VCR.eject_cassette
  end

  #describe 'listing add_ons' do
    before do
      VCR.insert_cassette 'add_on_list_request', record: :new_episodes
    end

    describe '.addon_list' do
      it 'lists addons' do
        expect(add_on.addon_list(name).class).to eq Array
        expect(
          add_on.addon_list(name).sort do |x,y|
            x['plan']['name'] <=> y['plan']['name']
          end.first['plan']['name']
        ).to eql 'heroku-postgresql:hobby-dev'
      end
    end

    describe '.addon_exists?' do
      describe 'addon present' do
        it 'is true' do
          expect(add_on.addon_exists?(name, 'heroku-postgresql:hobby-dev')).to be_truthy
        end
      end
      describe 'new addon' do
        it 'is false' do
          expect(add_on.addon_exists?(name, 'foo')).to_not be_truthy
        end
      end
    end
  #end

  describe '.set_addons' do
    describe 'when new addon' do
      it 'creates the addon' do
        VCR.eject_cassette
        add_on_name = 'newrelic'
        VCR.insert_cassette 'create_new_add_on_request', record: :new_episodes do
          add_on.set_addons(name, [add_on_name])
        end
        VCR.insert_cassette 'verify_new_add_on_request', record: :new_episodes do
          expect(add_on.addon_exists?(name, add_on_name)).to be_truthy
        end
      end
    end

    describe 'when existing addon' do
      # before do
      #   VCR.insert_cassette 'add_on_list_request', record: :new_episodes
      # end

      it 'makes no changes' do
        add_on_name = 'heroku-postgresql:hobby-dev'
        add_on.set_addons(name, [add_on_name])
        expect(add_on.addon_exists?(name, add_on_name)).to be_truthy
      end
    end
  end
end
