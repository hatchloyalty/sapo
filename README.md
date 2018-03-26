# Sapo

This gem is an exploration of techniques and tools that we can use to manipulate
the Salesforce Marketing Cloud.

- [] Configurable with dotenv
- [x] Get an OAuth token
- [] Start building around the Data Extensions API: List extensions.
- [] Convert Authorization code to Faraday
- [] Create a new extension randomly.
- [] Delete an extension
- [] Push data into the extension.
- [] Somehow describe the structure of a Data Extension, then push that into SFMC
- [] Handle modification of the Data Extension by reading teh current state,
  then developting a strategy for updating it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sapo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sapo

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/sapo.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
