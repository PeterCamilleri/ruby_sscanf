# RubySscanf

The ruby_sscanf gem monkey patches the String class to ass the sscanf instance
method. This method is modeled after the POSIX "C" standard sscanf but with
alterations and omissions to suit the Ruby programming language.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_sscanf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_sscanf

## Usage

The basic usage for sscanf is:

```ruby
"<input string>".sscanf("<format string>")
```

<br>where the input string is a collection of formatted information and the
format string is a description of that format.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/PeterCamilleri/ruby_sscanf.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

