require 'nokogiri'
require 'geo_swap'
require 'pry'

module TF1Converter
  class Translation
    def self.from(file)
      new(file)
    end

    def initialize(gpx_file)
      @gpx = Nokogiri::XML(gpx_file)
      @gpx.remove_namespaces!
    end

    def into(output_file)
      @kml ||= build_kml_from(@gpx)
      output_file.puts @kml.to_xml
      output_file.close
    end

    def build_kml_from(gpx)
      icon_path = Config.icon_path
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.kml('xmlns' => 'http://www.opengis.net/kml/2.2') do
          xml.Document do
            xml.open 1
            xml.Snippet(maxLines: '1')
            xml.description do
              xml.cdata "#{Time.now.strftime('%m-%d-%Y %I:%M:%S %p')}<br/><br/>TF1 Converter Version 1.0<br/>MO Task Force 1<br/>"
            end

            xml.Style(id: "sn_noicon") { xml.IconStyle { xml.Icon } }

            xml.Folder do
              xml.name "Waypoints"

              gpx.xpath('//gpx/wpt').each do |waypoint|
                xml.Placemark do
                  xml.name(waypoint.xpath('//name').first.text)
                  xml.Snippet(maxLines: '0')
                  xml.Style(id: 'normalPlacemark') do
                    xml.IconStyle do
                      xml.Icon do
                        #TODO: put this path in a config file
                        xml.href("#{icon_path}#{icon_name_for(waypoint)}")
                      end
                    end
                  end

                  lat = waypoint.attribute("lat").value
                  long = waypoint.attribute("lon").value

                  xml.description do
                    xml.cdata description_for(waypoint, lat, long)
                  end

                  xml.Point do
                    xml.coordinates "#{long},#{lat}"
                  end
                end
              end
            end

            xml.Folder do
              xml.name "Tracks"

              gpx.xpath('//gpx/trk').each do |track|
                name = track.xpath('//name').first.text
                xml.Style(id: "#{name}_Style") do
                  xml.LineStyle do
                    xml.color(color_for(track.xpath('//DisplayColor').first.text))
                    xml.width 3
                  end
                end

                xml.Placemark(id: name) do
                  xml.name name
                  xml.description do
                    xml.cdata "KML file, track, and waypoint comment."
                  end
                  xml.styleUrl "##{name}_Style"
                  xml.LineString do
                    xml.extrude 1
                    xml.tessellate 1
                    xml.altitudeMode 'clampedToGround'
                    xml.coordinates(coordinates_for(track))
                  end
                end

              end

            end
          end
        end
      end
    end

    def icon_name_for(waypoint)
      sym = field_for(waypoint, 'sym')
      Config.icons[sym]['icon']
    end

    def description_for(waypoint, lat, long)
      utm = GeoSwap.lat_long_to_utm(lat.to_f, long.to_f)
      usng = GeoSwap.utm_to_usng(utm.easting, utm.northing, utm.zone.number, utm.zone.letter)
      desc = ""
      desc << field_for(waypoint, 'cmt')
      desc << '<br>' << Config.icons[field_for(waypoint, 'sym')]['meaning']
      desc << '<br>' << "KML file, track, and waypoint comment."
      desc << "<br>" << "USNG:  #{usng}"
      desc << "<br>" << "UTM:  #{utm.to_s}"
      desc << "<br>" << "#{Config.start_path} - #{Config.end_path}"
    end

    def color_for(color)
      Config.colors[color]
    end

    def coordinates_for(track)
      track.xpath('//trkseg/trkpt').inject([]) { |points, trackpoint|
        points << ("" << trackpoint.attribute('lon').value.strip << ',' << trackpoint.attribute('lat').value.strip << ',0')
      }.join(' ')
    end

    def field_for(waypoint, field)
      waypoint.children.select{|c| c.name == field }.first.text
    end

  end
end
