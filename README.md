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
During execution of the sscanf method, each element in the format string is
used to find the corresponding data in the input string, optionally placing
the extracted data in the aforementioned output array. If a format element
cannot be matched to input data, processing stops at that point. Otherwise
processing continues until all the format elements are done.

Literal string components match themselves in the input string. If the literal
has a trailing space, then this matches zero or more spaces.
The special sequence '%%' matches one '%' in the input string.

The layout of a format specifier is:

    %[skip_flag][width]format

* The % sign is the lead-in character.
* The optional skip flag, the *, causes any data extracted to be ignored.
* The width field is an integer that determines the amount of text to be
parsed.
* The format field determines the type of data being parsed.

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
```

## Benchmarks

I ran a test just to make sure that ruby_sscanf was not terribly
under-performant when compared to the ruby standard library version. I was
pleased to see that in fact ruby_sscanf was faster. Here are the results:

    Calculating -------------------------------------
    Scan strings with ruby_sscanf
                             1.520k i/100ms
    Scan strings with scanf
                           308.000  i/100ms
    -------------------------------------------------
    Scan strings with ruby_sscanf
                             15.844k (± 5.2%) i/s -     79.040k
    Scan strings with scanf
                              3.127k (± 4.2%) i/s -     15.708k

    Comparison:
    Scan strings with ruby_sscanf:    15843.8 i/s
    Scan strings with scanf:     3126.7 i/s - 5.07x slower


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

