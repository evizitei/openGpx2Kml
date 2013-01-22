example = %Q{<Placemark>
		<name>001</name>
		<Snippet maxLines="0"></Snippet>
		<Style id="normalPlacemark">
			<IconStyle>
				<Icon>
					<href>c:\program files\gpx2kml\icon\tf_ge\01.png</href>
				</Icon>
			</IconStyle>
		</Style>
		<description><![CDATA[18-OCT-09 2:17:38PM<br>Search Start<br>KML file, track, and waypoint comment.<br>USNG:  15SWD6092208133<br>UTM:  15S 560921.64 4308133.45<br>c:\program files\gpx2kml\test - c:\program files\gpx2kml\test]]></description>
		<Point>
			<coordinates>-92.2972443,38.9199972</coordinates>
		</Point>
	</Placemark>
}

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
