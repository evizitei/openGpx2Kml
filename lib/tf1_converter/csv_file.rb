require 'csv'

module TF1Converter
  class CsvFile
    def initialize(waypoints, path)
      @waypoints = waypoints
      @path = path
    end

    def to_csv!
      CSV.open(@path, 'wb') do |csv|
        csv << ['filename', 'name', 'meaning', 'time', 'lat', 'long', 'usng', 'elevation']
        @waypoints.each do |wp|
          csv << [@path.split('.').first, wp.name, wp.icon_meaning, wp.timestamp, wp.lat, wp.long, wp.usng, wp.elevation]
        end
      end
    end

    def self.translate_filename(file_path)
      file_path.split('.')[0...-1].join('.') + '.csv'
    end
  end
end
