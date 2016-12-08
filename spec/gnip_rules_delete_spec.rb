require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  subject {base.new url, user, pass}

  context '#delete' do
    let(:instance) {base.new url, user, pass}

    it 'deletes rule' do
      instance.hashtag('foo').hashtag('bar').hashtag('baz')
      expect(instance.batch).to eq([{'value' => '#foo #bar #baz', "tag" => nil}])
      result = instance.delete
      expect(result).to eq(true)
    end

    it 'deletes many rules' do
      instance.hashtag('foo').hashtag('bar').hashtag('baz')
      instance.batch
      instance.hashtag('biz').hashtag('boz').hashtag('fuz')
      instance.batch
      # expect(instance.batch).to eq([
      #   {'value' => '#foo #bar #baz'},
      #   {'value' => '#biz #boz #fuz'}])
      expect(instance.delete).to eq(true)
    end

    it 'deletes place rule' do
      instance.hashtag('foo').hashtag('bar').hashtag('baz').place('abc123')
      expect(instance.batch).to eq([{'value' => '#foo #bar #baz place:abc123', "tag" => nil}])
      expect(instance.delete).to eq(true)
    end
  end

end
