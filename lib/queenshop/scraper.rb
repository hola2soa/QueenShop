#!/usr/bin/env ruby
require 'oga'
require 'iconv'
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
      ic = Iconv.new('UTF-8','big5')
      data = ic.iconv(raw_html.read)
      Oga.parse_html(data)
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
        title = item.xpath(@title_selector).text()
        price = item.xpath(@price_selector).text
        strip_filter(title, price) unless title.chomp().empty?
      end
      @result
    end

    def strip_filter (title, price)
      price = price.gsub!(/NT. /, '')
      if !@price_filter.empty?
        if eval("#{price} #{@price_filter}")
          @result << { title: "#{title}", price: "#{price}" }
        end
      else
        @result << { title: "#{title}", price: "#{price}" } unless title.empty?
      end

    end

    public

    def initialize
      @result = []
      # xml selectors that will be used to scrape data
      @item_selector = "//div[@class=\'pditem\']/div[@class=\'pdicon\']"
      @title_selector = "div[@class=\'pdicon_name\']/a"
      @price_selector = "div[@class=\'pdicon_price\']/div[@style=\'font-weight:bold;\']"
      @site_url = 'https://www.queenshop.com.tw/m/PDList2.asp?'
      @price_filter = nil
    end

    def scrape (params=[])
      params = ARGV.empty? ? params : ARGV
      conf = QConfig.new(params)
      @price_filter = conf.parameters[:price]
      search = "/text()[contains(
        translate(.,'ABCDEFGHIJKLOMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),
        translate('#{conf.parameters[:item]}','ABCDEFGHIJKLOMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]"
      @title_selector << search

      conf.pages.map do |page|
        paginated_uri = "&page=#{page}"
        fetch_result(paginated_uri)
      end
      @result
    end

  end
end
