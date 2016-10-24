def rules_json
  [
    { 'value' => '#someballerhashtag', 'tag' => 'mytag' }
  ].to_json
end

#To Run these tests and generate NEW cassettes (if features are added or changed), you need to put in the REAL values here and DO NOT commit them to the repo, 
#they will be gsubbed out (see spec_helper.rb)

def url
  'https://api.gnip.com/accounts/foo/publishers/twitter/streams/track/dev/rules.json'
end

def user
  'username'
end

def pass
  'password'
end
