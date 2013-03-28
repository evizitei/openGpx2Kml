module TF1Converter
  class Environment
    def self.process(config_file)
      TF1Converter::Config.load(config_file)
      input_path = TF1Converter::Config.input
      output_path = TF1Converter::Config.output

      Dir.foreach(input_path) do |file|
        if TF1Converter::Translation.can_translate?(file)
          input = File.open("#{input_path}/#{file}", 'r')
          outfile = file.gsub(/\.gpx$/, '.kml')
          output = File.open("#{output_path}/#{outfile}", 'w')
          TF1Converter::Translation.from(input).into(output)
        end
      end

      Dir.foreach(output_path) do |file|
        File.delete(File.join(output_path, file)) if file =~ /\.kml$/
      end
    end
  end
end
