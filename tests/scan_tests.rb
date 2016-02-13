require_relative '../lib/ruby_sscanf'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'


# Test the internals of the parser engine. This is not the normal interface.
class ScanTester < Minitest::Test

  #Track mini-test progress.
  MinitestVisible.track self, __FILE__

  def test_that_it_can_scan
    result = "12 34 -56".sscanf "%d %2d %4d"
    assert_equal([12, 34, -56] , result)

    result = "255 0b11111111 0377 0xFF 0 ".sscanf "%i %i %i %i %i"
    assert_equal([255, 255, 255, 255, 0] , result)

    result = "7 10 377".sscanf "%o %o %o"
    assert_equal([7, 8, 255] , result)

    result = "10 10011 11110000".sscanf "%b %b %b"
    assert_equal([2, 19, 240] , result)

    result = "0 F FF FFF FFFF".sscanf "%x %x %x %x %x"
    assert_equal([0, 15, 255, 4095, 65535] , result)

    result = "0 F FF FFF FFFF".sscanf "%X %*x %*X %x %X"
    assert_equal([0, 4095, 65535] , result)

    result = "Hello Silly World".sscanf "%s %*s %s"
    assert_equal(["Hello", "World"] , result)

    result = "Hello Silly World".sscanf "%5c %*5c %5c"
    assert_equal(["Hello", "World"] , result)

    result = "42 The secret is X".sscanf "%i %-1c"
    assert_equal([42, "The secret is X"] , result)

    result = "42 The secret is X".sscanf "%i %-2c%c"
    assert_equal([42, "The secret is ", "X"] , result)

    result = "42 The secret is X".sscanf "%i %*-2c%c"
    assert_equal([42,  "X"] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%a %e %g"
    assert_equal([9.99, 1.234e56, -1e100] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%*a %e %g"
    assert_equal([1.234e56, -1e100] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%a %*e %g"
    assert_equal([9.99, -1e100] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%a %e %*g"
    assert_equal([9.99, 1.234e56] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%A %E %G"
    assert_equal([9.99, 1.234e56, -1e100] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%A %*E %G"
    assert_equal([9.99, -1e100] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%f %f %f"
    assert_equal([9.99, 1.234e56, -1e100] , result)

    result = "9.99 1.234e56 -1e100".sscanf "%F %*F %F"
    assert_equal([9.99, -1e100] , result)

    result = "85% 75%".sscanf "%f%% %f%%"
    assert_equal([85, 75] , result)

    result = "12 34 -56".sscanf "%u %u %u"
    assert_equal([12, 34] , result)

    result = "1/2 3/4r -5/6".sscanf "%r %r %r"
    assert_equal(['1/2'.to_r, '3/4'.to_r, '-5/6'.to_r] , result)

    result = "1+2i 3+4j -5e10-6.2i".sscanf "%j %j %j"
    assert_equal([Complex('1+2i'), Complex('3+4j'), Complex('-5e10-6.2i')] , result)

    result = "'quote' 'silly' \"un quote\" 'a \\''  ".sscanf "%q %*q %q %q"
    assert_equal(["quote", "un quote", "a '"] , result)

    result = "a b c".sscanf "%[a] %[b] %[c]"
    assert_equal(["a", "b", "c"] , result)
  end

end
