# require 'gpx2kml'

# g = Gpx2kml.new
# g.add_files('input/test.gpx')
# g.build_kml('30e-5')
# g.save('output/test.kml')

require_relative './lib/tf1_converter'

input = File.open('input/test.gpx', 'r')
output = File.open('output/test.kml', 'w')
TF1Converter::Config.load('example/config.csv')
TF1Converter::Translation.from(input).into(output)
