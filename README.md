# QueenShop API [![Gem Version](https://badge.fury.io/rb/queenshop.svg)](https://badge.fury.io/rb/queenshop) [![Build Status](https://travis-ci.org/hola2soa/QueenShop.svg?branch=master)](https://travis-ci.org/hola2soa/QueenShop)

Queenshop is an ecommerce website selling women clothing but does not have an api.
This API allows the scrapping of the site to extract the title and price
of items sold. The api allows price and item to be specified as parameter.

Note that Queenshop does not have a robots.txt. checked on(Oct 18, 2015)

## Usage

Install queenshop api using this command:
```sh
$ gem install queenshop
```

You can execute it from the command line. Assume you want to get the items
which have their price more than 300 the following command
will produce the list of item/price:
```sh
$ queenshop --price=">300"
```
More parameters and examples:
```sh
comparator can be: < or < or <= or >= or ==
Usage: queenshop [options]
      price="comparator(float)"
      item=(string)
      pages=(int[..int])
      examples:
          queenshop price="==290" pages=2
          queenshop item="blouse" price="<300" pages=1..10
          queenshop price=">200" pages=3..5
```

If you want to use it in your library:
```ruby
require 'queenshop'
scraper = QueenShopScraper::Filter.new
results = scraper.scrape(['price=<300', 'pages=1..3'])
```
