require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  subject {base.new url, user, pass}

  context '#delete' do
    let(:instance) {base.new url, user, pass}

    it 'deletes rule' do
      instance.hashtag('foo').hashtag('bar').hashtag('baz')
      expect(instance.batch).to eq([{'value' => '#bar #baz #foo ', "tag" => nil}])
      expect(instance.delete).to eq(true)
    end

    it 'deletes many rules' do
      instance.hashtag('foo').hashtag('bar').hashtag('baz')
      instance.batch
      instance.hashtag('biz').hashtag('boz').hashtag('fuz')
      expect(instance.batch).to eq([
        {'value' => '#bar #baz #foo ', 'tag' => nil}, 
        {'value' => '#biz #boz #fuz ', 'tag' => nil}])
      expect(instance.delete).to eq(true)
    end
  end

end
