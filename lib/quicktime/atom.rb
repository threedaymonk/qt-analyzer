module QuickTime
  class Atom
    CONTAINERS = %w[
      moov trak udta tref imap mdia minf stbl edts mdra rmra imag vnrp dinf
    ]

    def initialize(io, start, max)
      @io, @start, @max = io, start, max
    end

    def header
      return @header if @header
      @io.seek(@start)
      length = @io.read(4).unpack('N')[0]
      name = @io.read(4)
      @header = {
        :name => name,
        :data_start => @start + 8,
        :length => length
      }
      case length
      when 0 # implied
        @header[:length] = @max - @start
      when 1 # extended
        a, b = @io.read(8).unpack('N*')
        @header[:length] = (a << 32) + b
        @header[:data_start] += 8
      end
      @header
    end

    def length
      header[:length]
    end

    def has_children?
      CONTAINERS.include?(name)
    end

    def children
      return [] unless has_children?

      children = []
      pos = header[:data_start]
      while pos < length
        atom = Atom.new(@io, pos, @start+length)
        pos += atom.length
        children << atom
      end
      children
    end

    def name
      header[:name]
    end

    def data_start
      header[:data_start]
    end
  end
end
