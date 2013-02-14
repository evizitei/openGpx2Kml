require 'nokogiri'
require 'builder'

module TF1Converter

  class Waypoint
    def initialize(gpx)
      @gpx = gpx
    end

    def to_xml
      gpx_doc = Nokogiri::XML(@gpx)
      wpt_node = gpx_doc.xpath('//wpt').first

      kml_builder = Builder::XmlMarkup.new

      kml_builder.placemark do |placemark|
        placemark.name(gpx_doc.xpath('//name').first.text)
        placemark.Snippet(:maxLines => "0")

        placemark.Style(:id => "normalPlacemark") do |style|
          style.IconStyle do |is|
            is.Icon do |i|
              i.href
            end
          end
        end

        placemark.description do |desc|
          timestamp = gpx_doc.xpath('//desc').first.text
          utm = nil
          usng = nil
          filepaths = ''
          desc.cdata!(%Q{#{timestamp}<br>Search Start<br>KML file, track, and waypoint comment.<br>USNG:  #{usng}<br>UTM:  #{utm}<br>#{filepaths}})
        end

        placemark.point do |point|
          lon = wpt_node.attributes['lon'].value
          lat = wpt_node.attributes['lat'].value
          coords = "#{lon},#{lat}"
          point.coordinates(coords)
        end
      end
    end

  end

end
