require_relative '../lib/waypoint'

module TF1Converter

  describe Waypoint do

    it 'converts gpx to xml waypoints' do
      gpx = %Q{
      <wpt lat="38.9199972" lon="-92.2972443">
      <ele>159.7036133</ele>
      <name>001</name>
      <cmt>18-OCT-09 2:17:38PM</cmt>
      <desc>18-OCT-09 2:17:38PM</desc>
      <sym>Custom 0</sym>
      <extensions>
        <gpxx:WaypointExtension xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">
          <gpxx:DisplayMode>SymbolAndName</gpxx:DisplayMode>
        </gpxx:WaypointExtension>
      </extensions>
    </wpt>
      }

      waypoint = Waypoint.new(gpx)
      kml = waypoint.to_xml
      kml.should =~ /<name>001<\/name>/
      kml.should =~ /<Snippet maxLines="0"/
      kml.should =~ /<Style id="normalPlacemark">/
      kml.should =~ /<coordinates>-92\.2972443,38\.9199972<\/coordinates>/
      kml.should =~ /CDATA\[18-OCT-09 2:17:38PM<br>Search Start<br>KML file, tracking, and waypoint comment.<br>USNG:  15SWD6092208133<br>UTM:  15S 560921.64 4308133.45<br>/
    end

  end

end
