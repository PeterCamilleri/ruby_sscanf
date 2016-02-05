# RubySscanf

The ruby_sscanf gem monkey patches the String class to support the sscanf
instance method. This method is modeled after the POSIX "C" standard sscanf
but with alterations and omissions to suit the Ruby programming language.

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
Where the input string is a collection of formatted information and the
format string is a description of that format. The output of the sscanf method
is an array of data extracted from the input string.

The format string consists of literal string components and format specifiers.

Literal string components match themselves in the input string. If the literal
has a trailing space, then this matches zero or more spaces. The special
sequence '%%' matches one '%'.

The layout of a format specifier is:

    %[skip_flag][width]format

* The % sign is the lead-in character.
* The optional skip flag, the * causes any data extracted to be ignored.
* The width field is an integer field that determines the amount of text to be
parsed.
* The format field determines the type of data being parsed.

The supported format field values are:
<br>
* b - Scan for an (optionally signed) binary number with an optional
leading '0b' or '0B'.
* c - Grab the next character. If a positive width is specified, grab width
characters. For a negative width, grab characters to the position from the
end of the input. For example a width of -1 will grab all of the remaining
input data.
* d - Scan for an (optionally signed) decimal number.
* f - Scan for an (optionally signed) floating point number.
* i - Scan for an (optionally signed) integer. If the number begins with '0x'
or '0X', process hexadecimal; with '0b' or '0B', process binary, if '0', '0o',
or '0O', process octal, else process decimal.
* j - Scan for an (optionally signed) complex number in the form
[+-]?float[+-]float[ij]
* o - Scan for an (optionally signed) octal number with an optional
leading '0', '0o' or '0O'.
* q - Scan for a quoted string. That is a string enclosed by either '...'
or "...".
* r - Scan for an (optionally signed) rational number in the form
[+-]?decimal/decimal[r]?
* s - Scan for a space terminated string.
* u - Scan for a decimal number.
* x - Scan for an (optionally signed) hexadecimal number with an optional
leading '0x' or '0X'.
* [chars] - Scan for a contiguous string of characters in the set [chars].
* [^chars] - Scan for a contiguous string of characters not in the set [^chars]

## Contributing

#### Plan A

1. Fork it ( https://github.com/PeterCamilleri/format_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

#### Plan B

Go to the GitHub repository and raise an issue calling attention to some
aspect that could use some TLC or a suggestion or idea. Apply labels to
the issue that match the point you are trying to make. Then follow your
issue and keep up-to-date as it is worked on. Or not as pleases you.
All input are greatly appreciated.

