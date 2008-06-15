require 'quicktime/atom'

module QuickTime
  class Movie
    def initialize(io, length)
      @io, @length = io, length
    end

    def atoms
      atoms = []
      pos = 0
      while pos < @length
        atom = Atom.new(@io, pos, @length)
        pos += atom.length
        atoms << atom
      end
      atoms
    end
  end
end
