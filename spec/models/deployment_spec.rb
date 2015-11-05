require 'spec_helper'

describe HerokuBuilder::Deployment do
  subject { described_class.new }
  let(:git) { spy('git') }
  before { allow(subject).to receive(:git).and_return git }

  describe '.remote_exists?' do
    before do
      allow(subject.git).to receive(:remotes).and_return([double(name: 'foo'), double(name: 'bar')])
    end
    context 'when remote exists' do
      it 'returns true' do
        expect(subject.remote_exists?('foo')).to be_truthy
      end
    end
    context 'when remote does not exists' do
      it 'returns true' do
        expect(subject.remote_exists?('foos')).to_not be_truthy
      end
    end
  end

  describe '.checkout' do
    it 'performs a checkout' do
      subject.checkout('foo')
      expect(git).to have_received(:fetch).once
      expect(git).to have_received(:checkout).once
      expect(git).to have_received(:pull).once
    end
  end
end
