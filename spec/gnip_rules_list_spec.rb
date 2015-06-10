require 'spec_helper'

describe Gnip::Ruler do

  let(:base){Gnip::Ruler}
  let(:response){'{"rules":[{"value":"#foo #bar","tag":null}]}'}
  subject {base.new url, user, pass}

  context '#list' do
    it 'gets a list of current rules' do
      expect(subject.list).to eq(json(response))
    end
  end
end
