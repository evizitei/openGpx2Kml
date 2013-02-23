require 'fileutils'
require 'zip/zip'

module TF1Converter
  class KmzFile
    def self.assemble!(filename)
      raw_name = filename.split(/[\/\\]/).last
      zip_path = "#{filename}.zip"
      FileUtils.rm(zip_path) if File.exists?(zip_path)
      Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE) do |zipfile|
        zipfile.add("#{raw_name}.kml", "#{filename}.kml")
        zipfile.mkdir("files")
        Dir.foreach(TF1Converter::Config.icon_path) do |item|
          if item != '.' && item != '..'
            zipfile.add("files/#{item}", "#{TF1Converter::Config.icon_path}/#{item}")
          end
        end
      end
      FileUtils.mv(zip_path, "#{filename}.kmz")
    end
  end
end
