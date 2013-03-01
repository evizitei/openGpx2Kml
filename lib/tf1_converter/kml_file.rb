module TF1Converter
  class KmlFile
    def initialize(waypoints, tracks, filename)
      @waypoints = waypoints
      @tracks = tracks
      @filename = filename
    end

    def to_xml
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.kml('xmlns' => 'http://www.opengis.net/kml/2.2') do
          xml.Document do
            write_xml_header(xml)

            xml.Folder do
              xml.name "Waypoints"
              @waypoints.each do |waypoint|
                write_waypoint_xml(waypoint, xml)
              end
            end

            xml.Folder do
              xml.name "Tracks"
              @tracks.each do |track|
                write_track_xml(track, xml)
              end
            end

          end
        end
      end.to_xml
    end

    private

    def write_xml_header(xml)
      xml.open 1
      xml.Snippet(maxLines: '1')
      xml.description do
        xml.cdata "#{Time.now.strftime('%m-%d-%Y %I:%M:%S %p')}<br/><br/>TF1 Converter Version 1.0<br/>MO Task Force 1<br/>"
      end
      xml.Style(id: "sn_noicon") { xml.IconStyle { xml.Icon } }
    end

    def write_waypoint_xml(waypoint, xml)
      xml.Placemark do
        xml.name(waypoint.name)
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


    def write_track_xml(track, xml)
      xml.Style(id: "#{track.name}_Style") do
        xml.LineStyle do
          xml.color next_color
          xml.width 3
        end
      end

      xml.Placemark(id: track.name) do
        xml.name track.name
        xml.description do
          xml.cdata @filename
        end
        xml.styleUrl "##{track.name}_Style"
        xml.LineString do
          xml.extrude 1
          xml.tessellate 1
          xml.altitudeMode 'clampedToGround'
          xml.coordinates track.coordinate_string
        end
      end
    end


    def description_for(waypoint)
      desc = ""
      desc << waypoint.timestamp
      desc << '<br>' << waypoint.icon_meaning
      desc << '<br>' << "Filename: #{@filename}"
      desc << "<br>" << "USNG:  #{waypoint.usng}"
      desc << "<br>" << "Lat,Long:  #{waypoint.lat},#{waypoint.long}"
      desc << "<br>" << "Elevation:  #{waypoint.elevation}"
    end

    def next_color
      @colors ||= Config.colors.values
      @color_index ||= 0
      return_color = @colors[@color_index]
      @color_index += 1
      if @color_index >= @colors.length
        @color_index = 0
      end
      return_color
    end

  end
end
