$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'quicktime/atom'
require 'stringio'

class QuickTimeAtomTest < Test::Unit::TestCase
  include QuickTime

  def test_should_not_have_children
    io = StringIO.new("\x00\x00\x00\x10zzzz........")
    a = Atom.new(io, 0, 16)
    assert !a.has_children?
  end

  def test_should_read_length
    io = StringIO.new("\x11\x22\x33\x44mdat")
    a = Atom.new(io, 0, 16)
    assert_equal 0x11223344, a.length
  end

  def test_should_read_name
    io = StringIO.new("\x11\x22\x33\x44foob")
    a = Atom.new(io, 0, 16)
    assert_equal 'foob', a.name
  end

  def test_should_read_extended_length
    io = StringIO.new("\x00\x00\x00\x01mdat\x11\x22\x33\x44\x55\x66\x77\x88....")
    a = Atom.new(io, 0, 16)
    assert_equal 0x1122334455667788, a.length
  end

  def test_should_use_implied_length
    io = StringIO.new("....\x00\x00\x00\x00mdat\x11\x22\x33\x44\x55\x66\x77\x88")
    a = Atom.new(io, 4, 1234)
    assert_equal 1230, a.length
  end

end

class QuickTimeAtomWithChildrenTest < Test::Unit::TestCase
  include QuickTime

  def setup
    io = StringIO.new("\x00\x00\x00\x1cmoov\x00\x00\x00\x0aabcd\xab\xcd\x00\x00\x00\x0aefef\xef\xef")
    @atom = Atom.new(io, 0, 1234)
  end
  attr_reader :atom

  def test_should_find_names_of_children
    assert_equal %w[ abcd efef ], atom.children.map{ |c| c.name }
  end

  def test_should_find_data_offsets_of_children
    assert_equal [ 16, 26 ], atom.children.map{ |c| c.data_start }
  end

  def test_should_have_children
    assert_equal 'moov', atom.name
    assert atom.has_children?
  end

end
