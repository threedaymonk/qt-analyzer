$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'quicktime/movie'
require 'stringio'

class QuickTimeSampleTest < Test::Unit::TestCase
  def setup
    filename = File.join(File.dirname(__FILE__), '..', 'samples', 'EmptyMovie.mov')
    length = File.size(filename)
    io = File.open(filename)
    @movie = QuickTime::Movie.new(io, length)
  end
  attr_reader :movie

  def test_should_find_one_top_level_atom_with_children
    assert_equal 1, movie.atoms.length
    atom = movie.atoms.first
    assert_equal 'moov', atom.name
    assert_equal 0x8c, atom.length
    assert atom.has_children?
  end

  def test_should_find_two_second_level_atoms
    assert_equal 2, movie.atoms.first.children.length
  end
end
