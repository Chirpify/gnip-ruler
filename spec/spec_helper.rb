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
