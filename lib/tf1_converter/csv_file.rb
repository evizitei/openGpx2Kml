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
          csv << [full_filename, wp.name, wp.icon_meaning, wp.timestamp, wp.lat, wp.long, wp.usng, ele_for(wp)]
        end
      end
    end

    def full_filename
      name = CsvFile.translate_filename(@path)
      if ::TF1Converter::Config.is_windows?
        name.gsub("/", "\\")
      else
        name
      end
    end

    def raw_path
      CsvFile.raw_path(@path)
    end

    def self.translate_filename(file_path)
      raw_path(file_path) + '.csv'
    end

    def self.raw_path(path)
      path.split('.')[0...-1].join('.')
    end

    private
    def ele_for(wp)
      if wp.elevation == Gpx::Waypoint::NoElevation
        ''
      else
        wp.elevation
      end
    end

  end
end
