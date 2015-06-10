require 'spec_helper'

describe Gnip::Ruler do

  let(:response){[{
    'value' => ['bar', 'foo'],
    'tag' => nil
  }]}

  subject {Gnip::Ruler.new url, user, pass}

  context '#list' do
    it 'gets a list of current rules' do
      expect(subject.list).to eq([{"value"=>"#foo #bar", "tag"=>nil}])
    end
  end
  context '#list' do
    it 'gets a list of current rules' do
      expect(subject.list_parsed).to eq(response[0])
    end
  end


end
