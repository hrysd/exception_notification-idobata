# ExceptionNotification for Idobata
[![Build Status](https://travis-ci.org/hrysd/exception_notification-idobata.png?branch=master)](https://travis-ci.org/hrysd/exception_notification-idobata)
[![Code Climate](https://codeclimate.com/github/hrysd/exception_notification-idobata.png)](https://codeclimate.com/github/hrysd/exception_notification-idobata)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exception_notification'
gem 'exception_notification-idobata'
```
And then execute:

```
$ bundle
```

## Usage

This plugin works by putting the following lines in your `config/environments/production.rb`

```ruby
Sample::Application.configure do
  config.middleware.use ExceptionNotification::Rack,
    idobata: {
      url:    HOOK_ENDPOINT,
      stage:  'Optional params as you like'
    }
end
```

![](https://cloud.githubusercontent.com/assets/1663465/6956243/f325a476-d925-11e4-82a3-ae4d24ea779d.png)

## Contributing

1. Fork it ( http://github.com/hrysd/exception_notification-idobata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
