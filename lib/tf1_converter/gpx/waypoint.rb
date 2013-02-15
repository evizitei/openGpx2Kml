module TF1Converter
  module Gpx
    class Waypoint
      def initialize(xml_node)
        @node = xml_node
      end

      def name
        @node.xpath('name').first.text
      end

      def icon_name
        Config.icons[symbol_name]['icon']
      end

      def icon_meaning
        Config.icons[symbol_name]['meaning']
      end

      def timestamp
        @node.children.select{ |child| child.name == 'cmt' }.first.text
      end

      def lat
        @node.attribute('lat').value
      end

      def long
        @node.attribute('lon').value
      end

      def usng
        u = utm_object
        GeoSwap.utm_to_usng(u.easting, u.northing, u.zone.number, u.zone.letter)
      end

      def utm
        utm_object.to_s
      end

      private

      def utm_object
        @_utm_object ||= GeoSwap.lat_long_to_utm(lat.to_f, long.to_f)
      end

      def symbol_name
        @node.children.select{ |child| child.name == 'sym' }.first.text
      end

    end
  end
end
