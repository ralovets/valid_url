# Valid Url

The accurate and reliable rails url validator (Rails 4).
*Valid Url* gem provides you with the ability to smart and easy validate URL.

## Installation

Add it to your Gemfile:

```ruby
gem 'valid_url'
```

Run the following command to install it:

```console
bundle install
```

## Usage

```ruby
class WebSite < ActiveRecord::Base
  validates :url, :url => true
end
```

If you would like to automatically update url's with missing protocols, use the `ensure_protocol` option:

```ruby
validates :url, :url => {:ensure_protocol => true}
```

This will update your attribute, prepending the default "https://" protocol. This way, urls without a protocol still pass validation, but don't get into your database without a valid protocol.

## Features

* Allow using *http*, *https* and *schema-less* urls. (will be configurable in future)
* Checking domain zones ([The Root Zone Database](http://www.iana.org/domains/root/db))
* Allow and validate ip-based hostnames.
* Checking name space specifications and terminology (RFC 1034, Section 3.1).
* Checking hostname characters.

## Motivation

Despite the fact that there are several good url validation gems on github none of them could satisfy strict standards and rules.

## Tests

The highest test coverage with more than a hundred different valid and invalid url examples.

## Contributors

Special thanks go to the **Addressable** gem author and contributors.
However, there are plans to abandon third-party libraries.

## License

This projected is licensed under the terms of the MIT license.