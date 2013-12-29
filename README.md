# Faraday::Response::Scrub
[![Build Status](https://travis-ci.org/Manbo-/faraday-response-scrub.png)](https://travis-ci.org/Manbo-/faraday-response-scrub)

## Installation

    $ git clone https://github.com/Manbo-/faraday-response-scrub
    $ cd faraday-response-scrub
    $ rake install

## Usage

    require "faraday/response/scrub"
    connection = Faraday.new do |builder|
      builder.use :scrub, encoding: "UTF-8", replace: "", text_only: true
      builder.adapter :net_http
    end
    connection.get(...).body

### encoding
default: UTF-8

encode response body with this value.

### replace
default: ""

replace invalid bytes with this value

### text_only
default: true

if true and response Content-Type doesn't include "text", skip 'scrub'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
