require_relative 'kml/track_node'
require_relative 'kml/placemark'

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
                Kml::TrackNode.new(track, @filename).write_to(xml)
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
        xml.cdata "#{Time.now.strftime('%m-%d-%Y %I:%M:%S %p')}<br/><br/>OpenGpx2Kml Converter Version 1.0<br/>"
      end
      xml.Style(id: "sn_noicon") { xml.IconStyle { xml.Icon } }
    end

    def write_waypoint_xml(waypoint, xml)
      placemark = Kml::Placemark.new(waypoint, @filename)
      placemark.write_to(xml)
    end

    

  end
end
