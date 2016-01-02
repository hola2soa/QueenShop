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

The first parameter represents the category you want to scrape. If no parameters
are passed then the "latest" category is scrapped.
The second parameter can be an integer to represent max number of pages
to scrape or it can be a string representing item title to filter. The third and
fourth parameter can be used to represent price range. Leaving the page limit to be
represented by the firth parameter. For example:

```sh
$ queenshop tops 20 # scrape 20 pages of tops category
$ queenshop pants "磨毛吊帶" 2 # scrape first two pages of pants category filter kw
$ queenshop latest 200 500 # scrape the latest category price matching 200 to 500
$ queenshop popular "Christmas" 400 500 2 # scrape 2 popular pages price 400 - 500
```
If you want to use it in your library:
```ruby
require 'queenshop'
scraper = QueenShopScraper::Filter.new
results = scraper.latest(1)
```
The following functions are available:
```ruby
scraper.latest(page_number_to_scrape[, options])
scraper.popular(page_number_to_scrape[, options])
scraper.pants(page_number_to_scrape[, options])
scraper.tops(page_number_to_scrape[, options])
scraper.accessories(page_number_to_scrape[, options])
scraper.scrape(what_section_to_scrape[, options])
```
options is an optional hash having keyword, page_limit,
price_boundary (array two numbers)
