module TF1Converter
  module Gpx
    class Waypoint
      def initialize(xml_node, icon_map = TF1Converter::Config.icons)
        @node = xml_node
        @icon_map = icon_map
      end

      def name
        @node.xpath('name').first.text
      end

      def icon_name
        if symbol_name
          map_entry = @icon_map[symbol_name]
          return map_entry['icon'] if map_entry
        end
        'default.png'
      end

      def icon_meaning
        if symbol_name
          map_entry = @icon_map[symbol_name]
          return map_entry['meaning'] if map_entry
        end
        'Default'
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
        sym_node = @node.children.select{ |child| child.name == 'sym' }.first
        if sym_node
          sym_node.text
        else
          nil
        end
      end

    end
  end
end
