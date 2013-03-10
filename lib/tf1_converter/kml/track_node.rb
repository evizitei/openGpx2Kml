require_relative 'track_color'

module TF1Converter
  module Kml
    class TrackNode
      def initialize(track, filename)
        @track = track
        @filename = filename
      end

      def write_to(xml)
        xml.Style(id: "#{@track.name}_Style") do
          xml.LineStyle do
            xml.color TrackColor.next
            xml.width 3
          end
        end

        xml.Placemark(id: @track.name) do
          xml.name @track.name
          xml.description do
            xml.cdata @filename
          end
          xml.styleUrl "##{@track.name}_Style"
          xml.LineString do
            xml.extrude 1
            xml.tessellate 1
            xml.altitudeMode 'clampedToGround'
            xml.coordinates @track.coordinate_string
          end
        end
      end

    end
  end
end
