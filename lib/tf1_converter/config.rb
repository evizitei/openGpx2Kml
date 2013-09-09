require 'csv'

module TF1Converter
  class Config

    def self.load(path)
      @last_key = nil
      @current_control = nil
      @constant_color_switch = false

      CSV.read(path).each do |row|
        parse_row(row)
      end
    end

    method_names = %w(icon_path icons colors input output use_constant_color platform)
    method_names.each do |name|
      define_singleton_method(name.to_sym) do
        instance_variable_get("@#{name}")
      end
    end

    def self.is_windows?
      self.platform == 'WINDOWS'
    end

    def self.parse_row(row)
      if @last_key == 'INPUT'
        @input = row[0]
      elsif @last_key == 'OUTPUT'
        @output = row[0]
      elsif @last_key == 'ICON_PATH'
        @icon_path = row[0]
      elsif @last_key == 'ICONS'
        @icons = {}
        @current_control = 'ICONS'
      elsif @last_key == 'COLORS'
        @colors = {}
        @current_control = 'COLORS'
      elsif @last_key == 'USE_CONSTANT_COLOR'
        @use_constant_color = row[0].strip.downcase == 'true'
      elsif @last_key == 'CONSTANT_COLOR'
        @constant_color = row[0]
      elsif @last_key == 'PLATFORM'
        @platform = row[0].strip.upcase
      end
      if @current_control == 'ICONS'
        if row.compact.empty?
          @current_control = nil
        else
          @icons[row[0]] = {
            'icon' => row[1],
            'meaning' => row[2],
            'name' => row[3]
          }
        end
      elsif @current_control == 'COLORS'
        if row.compact.empty?
          @current_control = nil
        else
          @colors[row[0]] = row[1]
        end
      end
      @last_key = row[0] ? row[0].upcase : nil
    end

    def self.constant_color
      colors[@constant_color]
    end

  end
end
