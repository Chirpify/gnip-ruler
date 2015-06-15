require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  subject {base.new url, user, pass}

  context '#add' do
    it 'adds rules' do
      expect(subject.make_add_request(rules_json)).to eq(true)
    end
  end

  context 'hashtag' do
    it 'will add hashtag to batch' do
      subject.hashtag('foo')
      expect(subject.batch).to eq([{"value"=>"#foo ", "tag"=>nil}])
    end

    it 'will add two hashtag to batch' do
      subject.hashtag('foo').hashtag('bar')
      expect(subject.batch).to eq([{"value"=>"#bar #foo ", "tag"=>nil}])
    end

    it 'will add two hashtags and tag batch' do
      subject.hashtag('foo').hashtag('bar').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#bar #foo ", "tag"=>'test-tag'}])
    end

    it 'will not add same hashtag twice' do
      subject.hashtag('foo').hashtag('bar').hashtag('foo').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#bar #foo ", "tag"=>'test-tag'}])
    end

    it 'will add a second hashtag pair to batch' do
      subject.hashtag('foo').hashtag('bar').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#bar #foo ", "tag"=>'test-tag'}])
      subject.hashtag('baz').hashtag('biz').tag('biz-tag')
      expect(subject.batch).to eq([
        {"value"=>"#bar #foo ", "tag"=>'test-tag'},
        {"value"=>"#baz #biz ", "tag"=>'biz-tag'}])
    end
  end

  context 'add hashtag rules' do
    let(:instance) {base.new url, user, pass}
    it 'formats and adds rules when we are done' do
      instance.hashtag('foo').hashtag('bar').hashtag('baz').tag('baztag')
      instance.batch
      expect(instance.add).to eq(true)
    end

    it 'disregard case' do
      instance.hashtag('Foo').hashtag('bar').tag('footag')
      expect(instance.batch).to eq ([{'value' => '#bar #foo ', 'tag' => 'footag'}])
      expect(instance.add).to eq(true)
    end

  end

end
