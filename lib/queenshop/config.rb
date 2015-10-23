#!/usr/bin/env ruby

# this class takes care of
# parsing the parameters
module Validate
  attr_reader :parameters
  attr_reader :pages

  VALID_ARGS = [:item, :price, :pages]

  def validate_args(args)
    @parameters = {item: '', price: '', pages: '1..2'}
    args.each do |arg|
      begin
        match = /(?<key>.*?)=(?<value>.*)/.match(arg)
        fail unless VALID_ARGS.include?(match[:key].to_sym)
        value = check(match)
        @parameters[match[:key].to_sym] = value
      rescue StandardError
        abort "invalid usage...\n" << usage << "\n\n"
      end
    end
  end # end validate_args

  def check(match)
    value = match[:value]
    Float(value) if match[:key].to_sym.eql?(:price)
    fail unless value =~ /^\d([.]{2}\d)?$/ if match[:key].to_sym.eql?(:pages)
    value
  rescue StandardError
      abort "invalid parameters"
  end

  def pages
    first_page = @parameters[:pages].scan(/\d+/).first.to_i
    last_page = @parameters[:pages].scan(/\d+/).last.to_i
    @pages = *(first_page..last_page)
  end

  def usage
    'Usage: queenshop [options]
      item=(string)
      price=(float[,float])
      examples:
              queenshop item=基本實搭多色圓領上衣 price=300
              queenshop price=0,100
              queenshop item=柔彩好搭雙'
  end
end

class Config
  include Validate
  def initialize (args)
    validate_args (args)
    pages
  end
end
