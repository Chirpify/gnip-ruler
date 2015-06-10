def rules_json
  { 
    'rules' => [
      { 'value' => '(gnip OR "this exact phrase") country_code:us', 'tag' => 'mytag' }
    ]
  }.to_json
end

def url
  'https://api.gnip.com/accounts/foo/publishers/twitter/streams/track/dev/rules.json'
end

def user
  'username'
end

def pass
  'password'
end
