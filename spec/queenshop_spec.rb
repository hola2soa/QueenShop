require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock/minitest'
require './lib/queenshop'

VCR.configure do |config|
  config.cassette_library_dir = './spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

VCR.use_cassette 'queenshop1' do
  describe 'queenshop' do
    before do
      @scraper = QueenShopScraper::Filter.new
    end

    describe 'fetch items from second page' do
      before do
        VCR.insert_cassette 'second page'
      end

      after do
        VCR.eject_cassette
      end

      it 'structure check' do
        items = @scraper.scrape(['pages=1..4'])

        items.must_be_instance_of Array
        items.wont_be_empty
        items.first.must_be_instance_of Hash
        items.wont_be_empty

        items.first[:title].wont_be_nil
        items.first[:title].must_be_instance_of String
        items.first[:price].wont_be_nil
        items.first[:price].must_be_instance_of String
      end
    end
  end
end
