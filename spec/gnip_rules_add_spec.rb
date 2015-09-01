require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  subject {base.new url, user, pass}

  context '#add' do
    it 'adds rules' do
      expect(subject.add_hashtags(rules_json)).to eq(true)
      #should clear out queued up changes
      expect(subject.batch).to be_empty
    end
  end

  context 'hashtag' do
    it 'will add hashtag to batch' do
      subject.hashtag('foo')
      expect(subject.batch).to eq([{"value"=>"#foo", "tag"=>nil}])
    end

    it 'will add two hashtag to batch' do
      subject.hashtag('bar').hashtag('foo')
      expect(subject.batch).to eq([{"value"=>"#bar #foo", "tag"=>nil}])
    end

    it 'will add two hashtags and tag batch' do
      subject.hashtag('bar').hashtag('foo').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#bar #foo", "tag"=>'test-tag'}])
    end

    it 'will not add same hashtag twice' do
      subject.hashtag('bar').hashtag('foo').hashtag('foo').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#bar #foo", "tag"=>'test-tag'}])
    end

    it 'will add a second hashtag pair to batch' do
      subject.hashtag('foo').hashtag('bar').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#foo #bar", "tag"=>'test-tag'}])
      subject.hashtag('baz').hashtag('biz').tag('biz-tag')
      expect(subject.batch).to eq([
        {"value"=>"#foo #bar", "tag"=>'test-tag'},
        {"value"=>"#baz #biz", "tag"=>'biz-tag'}])
    end

    it 'will not add empty hashtag' do
      subject.hashtag('foo').hashtag('bar').tag('test-tag')
      subject.hashtag('')
      expect(subject.batch).to eq([{"value"=>"#foo #bar", "tag"=>'test-tag'}])
    end

    it 'will show the current pre-json batch' do
      subject.hashtag('bar').hashtag('foo').tag('test-tag')
      expect(subject.batch).to eq([{"value"=>"#bar #foo", "tag"=>'test-tag'}])
      expect(subject.show).to eq([{"value"=>"#bar #foo", "tag"=>'test-tag'}])
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
      expect(instance.batch).to eq ([{'value' => '#foo #bar', 'tag' => 'footag'}])
      expect(instance.add).to eq(true)
    end
    
    it 'reset wipes out batch' do
      instance.reset
      expect(instance.batch).to be_empty
    end
    
  end

  context "location" do
    it 'hashtag and location' do
      subject.hashtag('Foo').hashtag('bar').tag('footag').lat(123).lon(45).radius(0.01)
      expect(subject.batch).to eq ([{"value"=>"#foo #bar point_radius:[123.0 45.0 0.01]", "tag"=>"footag"}])
    end

    it 'location and hashtag' do
      subject.lat(123).lon(45).radius(0.01).hashtag('Foo').hashtag('bar').tag('footag')
      expect(subject.batch).to eq ([{"value"=>"#foo #bar point_radius:[123.0 45.0 0.01]", "tag"=>"footag"}])
    end

    it 'location only' do
      subject.lat(123).lon(45).radius(0.01).tag('footag')
      expect(subject.batch).to eq ([{"value"=>"point_radius:[123.0 45.0 0.01]", "tag"=>"footag"}])
    end

    it 'hammajang order' do
      subject.lat(123).hashtag('Foo').lon(45).hashtag('bar').tag('footag').radius(0.01)
      expect(subject.batch).to eq ([{"value"=>"#foo #bar point_radius:[123.0 45.0 0.01]", "tag"=>"footag"}])
    end

  end

end
