# ExceptionNotification for Idobata [![Build Status](https://travis-ci.org/hrysd/exception_notification-idobata.png?branch=master)](https://travis-ci.org/hrysd/exception_notification-idobata)

## Installation

Add this line to your application's Gemfile:

    gem 'exception_notification-idobata', github: 'hrysd/exception_notification-idobata'

And then execute:

    $ bundle

## Usage

```ruby
Sample::Application.configure do
  config.middleware.use
    ExceptionNotification::Rack,
    idobata: {
      url: HOOK_ENDPOINT
    }
end
```

![](https://f.cloud.github.com/assets/1663465/2419367/38329928-ab5c-11e3-8137-c9969848e52f.png)

## Contributing

1. Fork it ( http://github.com/hrysd/exception_notification-idobata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
