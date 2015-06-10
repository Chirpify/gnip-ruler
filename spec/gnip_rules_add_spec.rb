require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  subject {base.new url, user, pass}

  context '#add' do
    it 'adds rules' do
      expect(subject.add(rules_json)).to eq(true)
    end

  end

  context 'add hashtag rules' do
    let(:instance) {base.new url, user, pass}
    it 'formats and adds rules when we are done' do
      instance.hashtag({'value' => ['foo', 'bar', 'baz'], 'tag' => 'baztag'})
      expect(instance.add).to eq(true)
    end

    it 'should return hashtags' do
      instance.hashtag({'value' => ['foo', 'bar']})
      expect(instance.rules).to eq ([{'value' => '#bar #foo', 'tag' => nil}])
    end

    it 'should be empty string' do
      instance.hashtag({})
      expect(instance.rules).to eq ([])
    end

    it 'should not add the same rule twice' do
      instance.hashtag({'value' => ['foo', 'bar']})
      instance.hashtag({'value' => ['foo', 'bar']})
      expect(instance.rules).to eq ([{'value' => '#bar #foo', 'tag' => nil}])
    end

    it 'tags are included' do
      instance.hashtag({'value' => ['foo', 'bar'], 'tag' => 'footag'})
      expect(instance.rules).to eq ([{'value' => '#bar #foo', 'tag' => 'footag'}])
    end

    it 'should add two different rules' do
      instance.hashtag({'value' => ['foo', 'bar']})
      instance.hashtag({'value' => ['baz', 'biz']})
      expect(instance.rules).to eq ([{'value' => '#bar #foo', 'tag' => nil}, {'value' => '#baz #biz', 'tag' => nil}])
    end

    it 'disregard case' do
      instance.hashtag({'value' => ['Foo', 'bar'], 'tag' => 'footag'})
      expect(instance.rules).to eq ([{'value' => '#bar #foo', 'tag' => 'footag'}])
      expect(instance.add).to eq(true)
    end

  end

end
