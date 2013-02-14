require 'yaml'

module TF1Converter
  class Config

    def self.load(path)
      @config = YAML.load(File.open(path, 'r'))
    end

    %w(icon_path start_path end_path icons colors input output).each do |name|
      define_singleton_method(name.to_sym) do
        config[name]
      end
    end

    private
    def self.config
      raise "NO CONFIG LOADED" unless @config
      @config['tf1_converter']
    end
  end
end