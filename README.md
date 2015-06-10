# Gnip::Twitter::Ruler


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnip-rules'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gnip-rules

## Usage

** Add rule to track hashtags **

Each rule represents the content a tweet must have to be picked up. Hashtags
are converted to `#foo` for Gnip.

```ruby
g = Gnip::Rules.new ENV['CHRP_GNIP_API_RULES_URL'], ENV['CHRP_GNIP_USERNAME'], ENV['CHRP_GNIP_PASSWORD']
g.hashtag({'value' => ['foo', 'bar', 'baz'], 'tag' => 'baztag'})
g.hashtag({'value' => ['baz', 'biz'], 'tag' => 'fiztag'})
g.add
```

Returns boolean.

** Delete hashtag rule **

Rules are exact. Rule `#foo #bar` is not the same as `#bar #foo`. The
Gnip::Ruler will alphabetize the hashtags array in order to have the highest
likelyhood of matching.

```ruby
g = Gnip::Rules.new ENV['CHRP_GNIP_API_RULES_URL'], ENV['CHRP_GNIP_USERNAME'], ENV['CHRP_GNIP_PASSWORD']
g.hashtag({'hashtags' => ['foo', 'bar', 'baz']})
g.delete
```

Returns boolean.

** List current rules **

__TODO: Implement hash'd result. Currently JSON repsonse__

```ruby
g = Gnip::Rules.new ENV['CHRP_GNIP_API_RULES_URL'], ENV['CHRP_GNIP_USERNAME'], ENV['CHRP_GNIP_PASSWORD']
g.list
```

Returns hash.

```ruby
{
    "rules" => [
        {
            "tag" => null,
            "value" => ['bar', 'foo']
        }
    ]
}
```


## Development

Todo: Implement hashtag location rule

## Tests

```
$ bundle install
$ bundle exec rspec
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip-rules/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
