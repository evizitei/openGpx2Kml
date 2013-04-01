require 'nokogiri'
require 'geo_swap'
require_relative 'gpx_file'
require_relative 'kml_file'
require_relative 'kmz_file'
require_relative 'csv_file'

module TF1Converter
  class Translation
    def self.from(file)
      new(file)
    end

    def self.can_translate?(filename)
      filename =~ /\.(gpx|GPX)$/
    end

    def initialize(gpx_file)
      @filename = File.basename(gpx_file.path).split('.').first
      parsed_gpx = Nokogiri::XML(gpx_file)
      parsed_gpx.remove_namespaces!
      @gpx = GpxFile.new(parsed_gpx)
    end

    def into(output_file)
      csv_file_name = CsvFile.translate_filename(output_file.path)
      CsvFile.new(@gpx.waypoints, csv_file_name).to_csv!

      kml = KmlFile.new(@gpx.waypoints, @gpx.tracks, @filename).to_xml
      output_file.puts kml
      output_file.close

      kmz = KmzFile.assemble!(csv_file_name.gsub(/\.csv$/,''))
    end

  end
end
