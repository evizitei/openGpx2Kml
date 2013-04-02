module TF1Converter
  describe Environment do
    describe '.translate_filename' do
      it 'changes gpx files into kml files' do
        Environment.translate_filename('somefile.gpx').should == 'somefile.kml'
      end

      it 'changes BIG gpx files into kml' do
        Environment.translate_filename('SOMEFILE.GPX').should == 'SOMEFILE.kml'
      end
    end
  end
end
