module TF1Converter
  module Kml
    class Placemark
      attr_reader :waypoint, :filename

      def initialize(waypoint, filename)
        @waypoint = waypoint
        @filename = filename
      end

      def write_to(xml)
        xml.Placemark do
          if ::TF1Converter::Config.show_ge_symbol_names?
            xml.name(waypoint.name)
          end
          xml.Snippet(maxLines: '0')
          xml.Style(id: 'normalPlacemark') do
            xml.IconStyle do
              xml.Icon do
                xml.href("files/#{waypoint.icon_name}")
              end
            end
          end

          xml.description do
            xml.cdata description_for(waypoint)
          end

          xml.Point do
            xml.coordinates "#{waypoint.long},#{waypoint.lat}"
          end
        end
      end

      private
      def description_for(waypoint)
        desc = ""
        desc << waypoint.timestamp
        desc << '<br>' << waypoint.name
        desc << '<br>' << waypoint.icon_meaning
        desc << '<br>' << "Filename: #{filename}"
        desc << "<br>" << "USNG:  #{waypoint.usng}"
        desc << "<br>" << "Lat,Long:  #{waypoint.lat},#{waypoint.long}"
        if waypoint.elevation.is_a? String
          desc << "<br>" << "Elevation:  #{waypoint.elevation}"
        end
        return desc
      end
    end
  end
end
