# RubySscanf

The ruby_sscanf gem monkey patches the String class to support the sscanf
instance method. This method is modeled after the POSIX "C" standard sscanf
but with alterations and omissions to suit the Ruby programming language.

It is noteworthy that this gem never was intended to be 100% compatible with
the built in scanf library. Some differences are:
* It deals only with strings and not IO objects.
* It adds formats for rational, complex, and quoted string data.
* It adopts a more uniform approach to eating (or not eating) superfluous spaces.
* Unsigned integer data are not allowed to be negative.

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
During execution of the sscanf method, each element in the format string is
used to find the corresponding data in the input string, optionally placing
the extracted data in the aforementioned output array. If a format element
cannot be matched to input data, processing stops at that point. Otherwise
processing continues until all the format elements are done.

Literal string components match themselves in the input string. If the literal
has a trailing space, then this matches zero or more spaces. The backslash
character is used as a quoting character. Thus \\\\ is processed as a single \\.
The special sequence '%%' matches one '%' in the input string. This is
equivalent to the sequence \\%.

The layouts of a format specifier are:

    %[skip_flag][width]format
    %[skip_flag][[min_width,]max_width]set
    %[skip_flag]regex[options]


* The % sign is the lead-in character.
* The optional skip flag, the *, causes any data extracted to be ignored.
* The width field is an integer that determines the amount of text to be
parsed. Note that a .precision field may be specified, but it is ignored.
* The format field determines the type of data being parsed.
* The min_width is the minimum allowed run of characters in the set.
* The max_width is the maximum allowed run of characters in the set.
* The set field is a regular expression style [...] set.
* The regex field is a full blown regular expression followed by options.

The supported format field values are:
<br>
* a,e,f,g,A,E,F,G - Scan for an (optionally signed) floating point or
scientific notation number.
* b - Scan for an (optionally signed) binary number with an optional
leading '0b' or '0B'.
* c - Grab the next character. If a positive width is specified, grab width
characters. For a negative width, grab characters to the position from the
end of the input. For example a width of -1 will grab all of the remaining
input data.
* d - Scan for an (optionally signed) decimal number.
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
* x,X - Scan for an (optionally signed) hexadecimal number with an optional
leading '0x' or '0X'.
* [chars] - Scan for a contiguous string of characters in the set [chars].
* [^chars] - Scan for a contiguous string of characters not in the set [^chars]
* /regex/ - Scan for a string matching the regular expression. This may be
followed by one or more optional flags. Supported flags are i, m, and x.

## Examples
Here are a few exmaples of the sscanf method in action.

```ruby
"12 34 -56".sscanf "%d %2d %4d"
returns   [12, 34, -56]

"255 0b11111111 0377 0xFF 0 ".sscanf "%i %i %i %i %i"
returns   [255, 255, 255, 255, 0]

"7 10 377".sscanf "%o %o %o"
returns   [7, 8, 255]

"10 10011 11110000".sscanf "%b %b %b"
returns   [2, 19, 240]

"0 F FF FFF FFFF".sscanf "%x %x %x %x %x"
returns   [0, 15, 255, 4095, 65535]

"Hello Silly World".sscanf "%s %*s %s"
returns   ["Hello", "World"]

"Hello Silly World".sscanf "%5c %*5c %5c"
returns   ["Hello", "World"]

"42 The secret is X".sscanf "%i %-1c"
returns   [42, "The secret is X"]

"42 The secret is X".sscanf "%i %-2c%c"
returns   [42, "The secret is ", "X"]

"42 The secret is X".sscanf "%i %*-2c%c"
returns   [42,  "X"]

"9.99 1.234e56 -1e100".sscanf "%f %f %f"
returns   [9.99, 1.234e56, -1e100]

"85% 75%".sscanf "%f%% %f%%"
returns   [85, 75]

"12 34 -56".sscanf "%u %u %u"
returns   [12, 34]

"1/2 3/4r -5/6".sscanf "%r %r %r"
returns   ['1/2'.to_r, '3/4'.to_r, '-5/6'.to_r]

"1+2i 3+4j -5e10-6.2i".sscanf "%j %j %j"
returns   [Complex('1+2i'), Complex('3+4j'), Complex('-5e10-6.2i')]

"'quote' 'silly' \"un quote\" 'a \\''  ".sscanf "%q %*q %q %q"
returns   ["quote", "un quote", "a '"]

"a b c".sscanf "%[a] %[b] %[c]"
returns   ["a", "b", "c"]

"a abbccc acbcad".sscanf "%/A/i %/a+b+c+/ %/([ab][cd])+/"
returns   ["a", "abbccc", "acbcad"]
```

## Getting unparsed text
When a string is parsed, there may be some text at the end of the string that
is not parsed. It is possible to retrieve this text using the following:

```ruby
String.sscanf_unparsed
```

## Benchmarks

I ran a test just to make sure that ruby_sscanf was not terribly
under-performant when compared to the ruby standard library version. I was
pleased to see that in fact ruby_sscanf was faster. Here are the results:

    Warming up --------------------------------------
    Scan strings with ruby_sscanf
                             1.768k i/100ms
    Scan strings with scanf
                           310.000  i/100ms
    Calculating -------------------------------------
    Scan strings with ruby_sscanf
                             18.355k (± 5.8%) i/s -     91.936k
    Scan strings with scanf
                              3.145k (± 7.2%) i/s -     15.810k

    Comparison:
    Scan strings with ruby_sscanf:    18354.7 i/s
    Scan strings with scanf:     3145.0 i/s - 5.84x slower

This benchmark test was run under:
* ruby 2.1.6p336 (2015-04-13 revision 50298) [i386-mingw32]
* format_engine version = 0.6.0

## Contributing

#### Plan A

1. Fork it ( https://github.com/PeterCamilleri/ruby_sscanf/fork )
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

