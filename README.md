# QueenShop API [![Gem Version](https://badge.fury.io/rb/queenshop.svg)](https://badge.fury.io/rb/queenshop) [![Build Status](https://travis-ci.org/hola2soa/QueenShop.svg?branch=master)](https://travis-ci.org/hola2soa/QueenShop)

Queenshop is an ecommerce website selling women clothing but does not have a public api.
This API allows the scrapping of the site to extract the title and price
of items sold.

Note that Queenshop does not have a robots.txt. checked on(Oct 18, 2015)

## Usage

Install queenshop api using this command:
```sh
$ gem install queenshop
```

The first parameter represents what you want to scrape and it is mandatory.
The second parameter can be an integer to represent max number of pages
to scrape or it can be a string representing item title to filter. If
the second parameter is a string, a third optional parameter can be supplied,
this will represent a price to filter items. Optionally a fourth parameter to
represent page limit to filter can be passed. If title or price is not needed
a -1 can be passed to avoid filtering. For example:

```sh
$ queenshop tops 20
$ queenshop pants "磨毛吊帶" 450
$ queenshop latest -1 500
$ queenshop popular "Christmas" -1
$ queenshop popular -1 -1 5
```
If you want to use it in your library:
```ruby
require 'queenshop'
scraper = QueenShopScraper::Filter.new
results = scraper.latest(1)
```
The following functions are available:
```ruby
scraper.latest(page_number_to_scrape[, page_limit])
scraper.popular(page_number_to_scrape[, page_limit])
scraper.pants(page_number_to_scrape[, page_limit])
scraper.tops(page_number_to_scrape[, page_limit])
scraper.accessories(page_number_to_scrape[, page_limit])
scraper.scrape(what_section_to_scrape, page_limit)
scraper.scrape_filter(what_section_to_scrape[, title, price, page_limit])
```
