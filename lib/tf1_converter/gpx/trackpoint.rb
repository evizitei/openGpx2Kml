module TF1Converter
  module Gpx
    class Trackpoint
      def initialize(xml_node)
        @node = xml_node
      end

      def lat
        @node.attribute('lat').value.strip
      end

      def long
        @node.attribute('lon').value.strip
      end

      def to_s
        "" << long << ',' << lat << ',0'
      end

    end
  end
end
