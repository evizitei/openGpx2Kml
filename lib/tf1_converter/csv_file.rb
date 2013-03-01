require 'csv'

module TF1Converter
  class CsvFile
    def initialize(waypoints, path)
      @waypoints = waypoints
      @path = path
    end

    def to_csv!
      CSV.open(@path, 'wb') do |csv|
        csv << ['filename', 'name', 'meaning', 'time', 'lat', 'long', 'usng']
        @waypoints.each do |wp|
          csv << [@path.split('.').first, wp.name, wp.icon_meaning, wp.timestamp, wp.lat, wp.long, wp.usng]
        end
      end
    end
  end
end
