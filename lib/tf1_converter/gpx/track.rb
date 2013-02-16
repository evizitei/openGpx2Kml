require_relative 'trackpoint'

module TF1Converter
  module Gpx
    class Track
      def initialize(xml_node, color_map = TF1Converter::Config.colors)
        @node = xml_node
        @color_map = color_map
      end

      def name
        @node.xpath('name').first.text
      end

      def display_color
        color_node = @node.xpath('extensions/TrackExtension/DisplayColor').first
        if color_node
          @color_map[color_node.text]
        else
          'f0000080'
        end
      end

      def coordinate_string
        trackpoints = @node.xpath('trkseg/trkpt').map{ |node| Trackpoint.new(node) }
        trackpoints.inject([]) { |points, tp| points << tp.to_s }.join(' ')
      end
    end
  end
end
