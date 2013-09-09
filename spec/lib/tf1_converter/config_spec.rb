require_relative '../../../lib/tf1_converter/config'

describe TF1Converter::Config do
  it 'does not overwrite colors later' do
    TF1Converter::Config.parse_row(['COLORS'])
    TF1Converter::Config.parse_row(['Red', '00ff1155'])
    TF1Converter::Config.parse_row(['Blue', '00ff1155'])
    TF1Converter::Config.parse_row(['Green', '00ff1155'])
    TF1Converter::Config.parse_row([nil, nil])
    TF1Converter::Config.parse_row(['USE_CONSTANT_COLOR'])
    TF1Converter::Config.parse_row(['Blue', nil])
    TF1Converter::Config.colors['Blue'].should_not be_nil
  end

  it "can load both platforms" do
    TF1Converter::Config.parse_row(["PLATFORM"])
    TF1Converter::Config.parse_row(['windows'])
    TF1Converter::Config.platform.should == "WINDOWS"
    TF1Converter::Config.is_windows?.should be_true

    TF1Converter::Config.parse_row(["PLATFORM"])
    TF1Converter::Config.parse_row(["mac"])
    TF1Converter::Config.platform.should == "MAC"
    TF1Converter::Config.is_windows?.should be_false
  end

  it 'has a configuration for displaying symbol names in google earth' do
    TF1Converter::Config.parse_row(["GE_SYMBOL_NAME"])
    TF1Converter::Config.parse_row(["ON"])
    TF1Converter::Config.show_ge_symbol_names?.should be_true

    TF1Converter::Config.parse_row(["GE_SYMBOL_NAME"])
    TF1Converter::Config.parse_row(["OFF"])
    TF1Converter::Config.show_ge_symbol_names?.should be_false
  end
end
