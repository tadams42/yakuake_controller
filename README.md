# YakuakeController

[![Gem Version](https://badge.fury.io/rb/yakuake_controller.svg)](https://badge.fury.io/rb/yakuake_controller)
[![Build Status](https://travis-ci.org/tadamic/yakuake_controller.svg?branch=development)](https://travis-ci.org/tadamic/yakuake_controller)

Ruby gem to interact with [Yakuake] through DBus.

## Installation

Add this line to your application's Gemfile:

    gem 'yakuake_controller'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yakuake_controller

## Usage

~~~ruby
require 'yakuake_controller'
client = YakuakeController::DBusClient.new
client.set_tab_title new_title: 'Foo', tab_index: 0
~~~

## Contributing

1. Fork it ( https://github.com/tadamic/yakuake_controller/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[Yakuake]:https://yakuake.kde.org/
