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

    #TODO: Config file
    ICON_PATH = "c:\\program files\\gpx2kml\\icon\\tf_ge\\"
    START_PATH = "c:\\program files\\gpx2kml\\test"
    END_PATH = "c:\\program files\\gpx2kml\\test"

    def build_kml_from(gpx)
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
                        xml.href("#{ICON_PATH}#{icon_name_for(waypoint)}")
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
          end
        end
      end
    end

    #TODO: put this in a yml file
    DATA_MAPPING = {
      'Custom 0' => { icon: '01.png', meaning: 'Search Start' },
      'Custom 1' => { icon: '02.png', meaning: 'Search Stop'},
      'Custom 2' => { icon: '03.png', meaning: 'Victim Detected'},
      'Custom 3' => { icon: '04.png', meaning: 'Victim Confirmed'},
      'Custom 4' => { icon: '05.png', meaning: 'Meaning 5'},
      'Custom 5' => { icon: '06.png', meaning: 'Meaning 6'},
      'Custom 6' => { icon: '07.png', meaning: 'Meaning 7'},
      'Custom 7' => { icon: '08.png', meaning: 'Meaning 8'},
      'Custom 8' => { icon: '09.png', meaning: 'Meaning 9'},
      'Custom 9' => { icon: '10.png', meaning: 'Meaning 10'},
      'Custom 10' => { icon: '11.png', meaning: 'Collection Point' },
      'Custom 11' => { icon: '12.png', meaning: 'Meaning 12'},
      'Custom 12' => { icon: '13.png', meaning: 'Command Post' },
      'Custom 13' => { icon: '14.png', meaning: 'Staging Area'},
      'Custom 14' => { icon: '15.png', meaning: 'Criminal Activity' },
      'Custom 15' => { icon: '16.png', meaning: 'Meaning 16'},
      'Custom 16' => { icon: '17.png', meaning: 'Water Level'},
      'Custom 17' => { icon: '18.png', meaning: 'Structure Damage / Safe' },
      'Custom 18' => { icon: '19.png', meaning: 'Meaning 19'},
      'Custom 19' => { icon: '20.png', meaning: 'Structure Not Safe' },
      'Custom 20' => { icon: '21.png', meaning: 'Extra 21' },
      'Custom 21' => { icon: '22.png', meaning: 'Extra 22' },
      'Custom 22' => { icon: '23.png', meaning: 'Extra 23'},
      'Residence' => { icon: 'default.png', meaning: 'Default' },
    }

    def icon_name_for(waypoint)
      sym = field_for(waypoint, 'sym')
      DATA_MAPPING[sym][:icon]
    end

    def description_for(waypoint, lat, long)
      utm = GeoSwap.lat_long_to_utm(lat.to_f, long.to_f)
      usng = GeoSwap.utm_to_usng(utm.easting, utm.northing, utm.zone.number, utm.zone.letter)
      desc = ""
      desc << field_for(waypoint, 'cmt')
      desc << '<br>' << DATA_MAPPING[field_for(waypoint, 'sym')][:meaning]
      desc << '<br>' << "KML file, track, and waypoint comment."
      desc << "<br>" << "USNG:  #{usng}"
      desc << "<br>" << "UTM:  #{utm.to_s}"
      desc << "<br>" << "#{START_PATH} - #{END_PATH}"
    end

    def field_for(waypoint, field)
      waypoint.children.select{|c| c.name == field }.first.text
    end

  end
end