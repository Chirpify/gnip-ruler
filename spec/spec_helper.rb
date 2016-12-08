#require '../lib'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test, :development)
require 'pry'
require 'bundler'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

# load up stub methods
require 'stubs'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('https://noneya/rules/powertrack/accounts/business/publishers/twitter/Development.json') { url }
  config.filter_sensitive_data('some auth header') { Base64.encode64("#{user}:#{pass}").chomp }
  # config.filter_sensitive_data("summary") { 'an auth header!' }
end

# Use explicit VCR fixtures for each test
# @todo there has to be a better way...
RSpec.configure do |config|
  config.around(:each) do |example|
    VCR.use_cassette(example.metadata[:full_description]) do
      example.run
    end
  end
end
