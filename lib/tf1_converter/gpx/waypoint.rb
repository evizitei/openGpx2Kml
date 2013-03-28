module TF1Converter
  module Gpx
    class Waypoint
      def initialize(xml_node, icon_map = TF1Converter::Config.icons)
        @node = xml_node
        @icon_map = icon_map
      end

      def name
        name_node = @node.xpath('name').first
        name_node.nil? ? '' : name_node.text
      end

      def icon_name
        if symbol_name
          map_entry = @icon_map[symbol_name]
          return map_entry['icon'] if map_entry
        end

        if name
          @icon_map.values.each do |icon_data|
            if icon_data['name']
              return icon_data['icon'] if icon_data['name'].upcase == name.slice(0,3).upcase
            end
          end
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
        cmt_node = @node.children.select{ |child| child.name == 'cmt' }.first
        return cmt_node.text if cmt_node
        @node.children.select{ |child| child.name == 'time' }.first.text
      end

      def lat
        @node.attribute('lat').value
      end

      def long
        @node.attribute('lon').value
      end

      def elevation
        @node.children.select{ |child| child.name == 'ele' }.first.text
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
