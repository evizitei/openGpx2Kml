require_relative 'gpx/waypoint'
require_relative 'gpx/track'

module TF1Converter
  class GpxFile
    def initialize(gpx_file)
      @gpx = gpx_file
    end

    def waypoints
      @gpx.xpath('//gpx/wpt').map{ |node| Gpx::Waypoint.new(node) }
    end

    def tracks
      @gpx.xpath('//gpx/trk').map{ |node| Gpx::Track.new(node) }
    end

  end
end
