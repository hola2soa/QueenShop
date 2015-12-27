require_relative 'spec_helper'

VCR.use_cassette 'queenshop' do
  describe 'check if queenshop tests pass' do
    before do
      @scraper = QueenShop::Scraper.new
    end

    describe 'fetch popular' do
      manage_cassettes 'popular items'
      it 'should check correct structure' do
        items = @scraper.popular(1)
        check_correct_structure items
      end
    end

    describe 'fetch pants' do
      manage_cassettes 'pants items'
      it 'should check correct structure' do
        items = @scraper.pants(1)
        check_correct_structure items
      end
    end

    describe 'fetch tops' do
      manage_cassettes 'tops items'
      it 'should check correct structure' do
        items = @scraper.tops(1)
        check_correct_structure items
      end
    end
  end
end
