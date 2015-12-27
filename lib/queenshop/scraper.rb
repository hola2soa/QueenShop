#!/usr/bin/env ruby
require 'oga'
require 'iconv'
require 'open-uri'
require 'miro'

# scrape data
module QueenShop
  # filter class uses xpath selectors to get attribs
  class Scraper
    BASE_URL        = 'https://queenshop.com.tw'
    BASE_SCRAPE_URL = "#{BASE_URL}/m/PDList2.asp?"
    # Hot items
    LATEST_URI      = "#{BASE_SCRAPE_URL}br=01&item1=new"
    DISCOUNT_URI    = "#{BASE_SCRAPE_URL}br=01&item1=dis"
    POPULAR_URI     = "#{BASE_SCRAPE_URL}br=01&item1=pre"
    TOPS_URI        = "#{BASE_SCRAPE_URL}brand=01&item1=00&item2=6"
    PANTS_URI       = "#{BASE_SCRAPE_URL}brand=01&item1=01&item2=3"
    ACCESSORIES_URI = "#{BASE_SCRAPE_URL}brand=01&item1=02&item2=2"

    # xml selectors that will be used to scrape data
    ITEM_SELECTOR   = "//div[@class='pditem']/div[@class='pdicon']"
    TITLE_SELECTOR  = "div[@class='pdicon_name']/a"
    IMAGE_SELECTOR  = "div[@class='pdicon_img']/a/img/@src"
    PRICE_SELECTOR  = "div[@class='pdicon_price']/div[@style='font-weight:bold;']"
    LINK_SELECTOR   = "div[@class='pdicon_name']/a/@href"
    PAGES_SELECTOR  = "div[@class='divPageClone']/a/@href"

    def latest(page)
      uri  = uri_with_page(LATEST_URI, page)
      body = fetch_data(uri)
      filter(body)
    end

    def popular(page)
      uri  = uri_with_page(POPULAR_URI, page)
      body = fetch_data(uri)
      filter(body)
    end

    def tops(page)
      uri  = uri_with_page(TOPS_URI, page)
      body = fetch_data(uri)
      filter(body)
    end

    def pants(page)
      uri  = uri_with_page(PANTS_URI, page)
      body = fetch_data(uri)
      filter(body)
    end

    def accessories(page)
      uri  = uri_with_page(ACCESSORIES_URI, page)
      body = fetch_data(uri)
      filter(body)
    end

    def scrape(type, page_limit = 10)
      records = []
      valid_args = [:tops, :popular, :pants, :pants, :accessories, :latest]
      abort 'invalid parameter - scrape type' unless valid_args.include?(type.to_sym)
      abort 'invalid parameter - page limit' unless page_limit.is_a? Integer
      scrape_what(type, page_limit)
    end

    def scrape_filter(type, title = -1, price = -1, page_limit = 10)
      results = scrape(type, page_limit)
      records = []
      results.each do |r|
        r.each do |b|
          if((title != -1 && (b[:title].downcase.include? title.downcase)) ||
            (price != -1 && b[:price].to_i == price.to_i))
            records.push(b)
          end
        end
      end
      records
    end

    private
    def uri_with_page(uri, page)
      "#{uri}&pageno=#{page}"
    end

    def fetch_data(uri)
      open(uri) {|file| file.read}
    rescue StandardError
      'error opening site url'
    end

    def filter(raw)
      Oga.parse_html(raw)
         .xpath(ITEM_SELECTOR)
         .map { |item| parse(item) }
    end

    def parse(item)
      images = extract_images(item)
      {
        title:  extract_title(item),
        price:  extract_price(item),
        images: images,
        # images_colors: extract_dominant_colors(images[0]), # just one image
        link:   extract_link(item)
      }
    end

    def extract_title(item)
      ic = Iconv.new('UTF-8','big5')
      raw_title = item.xpath(TITLE_SELECTOR).text
      ic.iconv(raw_title)
    end

    def extract_price(item)
      item.xpath(PRICE_SELECTOR).text.sub(/NT. /, '').to_i
    end

    def extract_images(item)
      image       = item.xpath(IMAGE_SELECTOR).text
      image_hover = image.sub(/\.jpg/, '-h.jpg')
      image_hover = image.sub(/\.png/, '-h.png') unless image_hover != image
      ["#{BASE_URL}#{image}", "#{BASE_URL}#{image_hover}"]
    end

    def extract_link(item)
      "#{BASE_URL}/#{item.xpath(LINK_SELECTOR).text}"
    end

    def extract_dominant_colors(image_path)
      Miro::DominantColors.new(image_path).to_hex
    end

    def scrape_what(type, page_limit)
      records = []
      1.upto(page_limit) do |page|
        method = self.method(type)
        records.push(method.call(page))
      end
      records
    end
  end
end
