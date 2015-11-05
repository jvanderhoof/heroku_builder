require 'spec_helper'

describe HerokuBuilder::Resource do
  let(:resource) { HerokuBuilder::Resource.new }
  let(:name) { 'hound-jason' }

  describe '.get_formation' do
    describe 'not present' do
    before do
      VCR.insert_cassette 'missing_formations_request', record: :new_episodes
    end

      it 'returns nil' do
        expect(resource.get_formation(name, 'foo')).to eq nil
      end
    end

    describe 'is present' do
      before do
        VCR.insert_cassette 'current_formations_request', record: :new_episodes
      end

      it 'returns resource' do
        expect(resource.get_formation(name, 'web')['app']['name']).to eq name
      end
    end

    describe '.set_resources' do
      before do
        VCR.insert_cassette 'updated_formations_request', record: :new_episodes
      end
      it 'updates a resource' do
        args = {'web' => {
          'count' =>  0,
          'type' =>  'Free' }
        }
        resource.set_resources(name, args)
        expect(resource.get_formation(name, 'web')['quantity']).to eq 0
      end
    end

  end
end
