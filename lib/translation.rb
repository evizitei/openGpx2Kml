require 'nokogiri'
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
                end
              end
            end
          end
        end
      end
    end

    #TODO: put this in a yml file
    ICON_MAPPING = {
      'Custom 0' => '01.png',
      'Custom 1' => '02.png',
      'Custom 2' => '03.png',
      'Custom 3' => '04.png',
      'Custom 4' => '05.png',
      'Custom 5' => '06.png',
      'Custom 6' => '07.png',
      'Custom 7' => '08.png',
      'Custom 8' => '09.png',
      'Custom 9' => '10.png',
      'Custom 10' => '11.png',
      'Custom 11' => '12.png',
      'Custom 12' => '13.png',
      'Custom 13' => '14.png',
      'Custom 14' => '15.png',
      'Custom 15' => '16.png',
      'Custom 16' => '17.png',
      'Custom 17' => '18.png',
      'Custom 18' => '19.png',
      'Custom 19' => '20.png',
      'Custom 20' => '21.png',
      'Custom 21' => '22.png',
      'Custom 22' => '23.png',
      'Residence' => 'default.png'
    }

    def icon_name_for(waypoint)
      sym = waypoint.children.select{|c| c.name == 'sym' }.first.text
      ICON_MAPPING[sym]
    end
  end
end