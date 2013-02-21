require 'nokogiri'
require 'geo_swap'
require_relative 'gpx_file'
require_relative 'kml_file'
require_relative 'csv_file'

module TF1Converter
  class Translation
    def self.from(file)
      new(file)
    end

    def initialize(gpx_file)
      parsed_gpx = Nokogiri::XML(gpx_file)
      parsed_gpx.remove_namespaces!
      @gpx = GpxFile.new(parsed_gpx)
    end

    def into(output_file)
      csv_path =output_file.path.split('.').first + '.csv'
      CsvFile.new(@gpx.waypoints, csv_path).to_csv!

      kml = KmlFile.new(@gpx.waypoints, @gpx.tracks).to_xml
      output_file.puts kml
      output_file.close
    end

  end
end
