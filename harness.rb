# require 'gpx2kml'

# g = Gpx2kml.new
# g.add_files('input/test.gpx')
# g.build_kml('30e-5')
# g.save('output/test.kml')

require_relative './lib/tf1_converter'

require 'fileutils'
FileUtils.rm('output/test.zip') if File.exists?('output/test.zip')

input = File.open('input/test.gpx', 'r')
output = File.open('output/test.kml', 'w')
TF1Converter::Config.load('example/localconfig.csv')
TF1Converter::Translation.from(input).into(output)
