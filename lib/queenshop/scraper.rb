#!/usr/bin/env ruby
require 'oga'
require 'open-uri'
require_relative './config'

# scrape data
module QueenShopScraper
  # filter class basically uses xpath selectors to get attribs
  class Filter
    attr_reader :result
    attr_writer :item_selector
    attr_writer :title_selector
    attr_writer :price_selector
    attr_writer :site_url

    private

    def get_xmldata(url)
      raw_html = open(url)
      Oga.parse_html(raw_html)
    rescue StandardError
      'error'
    end

    def fetch_result(uri = '')
      url = @site_url + uri
      # try to open the url
      document = get_xmldata(url)
      # hard return on an error
      return [] unless document != 'error'

      items = document.xpath(@item_selector)
      # loop through the items and get the title and price
      items.map do |item|
        title = item.xpath(@title_selector).text.force_encoding('UTF-8')
        price = item.xpath(@price_selector).text
        @result << { title: "#{title}",
        price: "#{price}" } unless title.empty?
      end
      @result
    end

    public

    def initialize
      @result = []
      # xml selectors that will be used to scrape data
      @item_selector = "//div[@class=\'pditem\']/div[@class=\'pdicon\']"
      @title_selector = "div[@class=\'pdicon_name\']/a"
      @price_selector = "div[@class=\'pdicon_price\']/div[@style=\'font-weight:bold;\']"
      @site_url = 'https://www.queenshop.com.tw/m/PDList2.asp?'
    end

    def scrape (params=[])
      params.concat(ARGV)
      conf = Config.new(params)

      @title_selector <<
      "[contains( text(), '#{conf.parameters[:item]}')]" if !conf.parameters[:item].empty?

      #@price_selector <<
      # "[translate(text(), 'NT. ', '')" if !conf.parameters[:price].empty?
      # #{conf.parameters[:price]}

      conf.pages.map do |page|
        paginated_uri = "&page=#{page}"
        fetch_result(paginated_uri)
      end
      @result
    end

  end
end
