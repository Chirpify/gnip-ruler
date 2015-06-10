require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  subject {base.new url, user, pass}

  context '#delete' do
    let(:instance) {base.new url, user, pass}

    it 'deletes rule' do
      instance.delete_hashtag({'value' => ['foo', 'bar', 'baz']})
      expect(instance.delete).to eq(true)
      expect(instance.delete_rules).to eq([{'value' => '#bar #baz #foo'}])
    end

    it 'deletes many rules' do
      instance.delete_hashtag({'value' => ['foo', 'bar', 'baz']})
      instance.delete_hashtag({'value' => ['biz', 'boz', 'fuz']})
      expect(instance.delete).to eq(true)
      expect(instance.delete_rules).to eq([{'value' => '#bar #baz #foo'}, {'value' => '#biz #boz #fuz'}])
    end
  end

end
