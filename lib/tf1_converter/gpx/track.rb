require_relative 'trackpoint'

module TF1Converter
  module Gpx
    class Track
      def initialize(xml_node)
        @node = xml_node
      end

      def name
        @node.xpath('name').first.text
      end

      def display_color
        color_name = @node.xpath('extensions/TrackExtension/DisplayColor').first.text
        Config.colors[color_name]
      end

      def coordinate_string
        trackpoints = @node.xpath('trkseg/trkpt').map{ |node| Trackpoint.new(node) }
        trackpoints.inject([]) { |points, tp| points << tp.to_s }.join(' ')
      end
    end
  end
end
