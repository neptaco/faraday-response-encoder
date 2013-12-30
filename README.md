# Faraday::Response::Encoder
[![Build Status](https://travis-ci.org/Manbo-/faraday-response-encoder.png)](https://travis-ci.org/Manbo-/faraday-response-encoder)

## Installation

    $ git clone https://github.com/Manbo-/faraday-response-encoder
    $ cd faraday-response-encoder
    $ rake install

## Usage

    require "faraday/response/encoder"
    connection = Faraday.new do |builder|
      builder.use :encoder, { source: "EUC-JP", encode: "UTF-8", replace: "",
                              text_only: true, if: ->(env){ ... } }
      builder.adapter :net_http
    end
    connection.get(...).body

### Options

#### source
default: charset value of http headers or UTF-8

specify encoding of response body

#### encoding
default: none

specify value to encode

#### replace 
default: ""

replace invalid bytes with this value

#### text_only
default: true

if true and response Content-Type doesn't include "text", skip encoding

#### if
example: if: ->(env){ env[:url] =~ %r(\Ahttp://github\.com/) }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
