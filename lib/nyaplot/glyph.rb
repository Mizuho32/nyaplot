module Nyaplot
  module Glyph
    class << self
      #@example
      # Nyaplot::Glyph.instantiate(:scatter)
      def instantiate(df, name, hash)
        glyph = Kernel
          .const_get("Nyaplot")
          .const_get("Glyph")
          .const_get(name.to_s.capitalize)

        glyph.new(hash).data(df)
      end
    end

    module Glyph2D
      include Nyaplot::Base
      type :glyph

      private
      def range(label)
        if data[label].all? {|v| v.is_a? Numeric}
          [data[label].min, data[label].max]
        else
          data[label].uniq
        end
      end

      def range_x
        self.range(x)
      end

      def range_y
        self.range(y)
      end
    end

    class Scatter
      include Nyaplot::Glyph2D
      required_args :data, :x, :y, :position
      optional_args :color, :shape, :size, :stroke_color, :stroke_width

      # Change symbol size according to data in specified column
      def size_by(column_name)
        scale = Nyaplot::RowScale.new(data, column_name)
        range = size.nil? ? [10, 100] : size
        scale.range(range)
        self.size(size)
      end

      # Change symbol shape according to data in specified column
      # Value range (ex. "circle", "diamond", ...) can be specified using Scatter#shape
      # @example
      #   x = ["a", "b", "a"]; y = [1, 2, 3]
      #   sc = Scatter.new(data: data, x: :x, y: :y)
      #   sc.shape_by(:x) #-> circle, triangle-up, circle (default)
      #   sc.shape([:square, :cross]).shape_by(:x) #-> square, cross, square
      #
      def shape_by(column_name)
        scale = Nyaplot::RowScale.new(data, column_name)
        range = shape.nil? ? ['circle','triangle-up', 'diamond', 'square', 'triangle-down', 'cross'] : shape
        scale.range(range)
        self.shape(scale)
      end
    end

    class Line
      include Nyaplot::Glyph2D
      required_args :data, :x, :y, :position
      optional_args :color, :stroke_width
    end
  end
end
