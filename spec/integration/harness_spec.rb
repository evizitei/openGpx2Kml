require 'tf1_converter'

describe 'running a directory of files' do
  it 'does not error out' do
    TF1Converter::Environment.process('spec/environment/config.csv')
  end
end
