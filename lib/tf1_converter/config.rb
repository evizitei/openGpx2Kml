require 'csv'

module TF1Converter
  class Config

    def self.load(path)
      last_key = nil
      current_control = nil
      CSV.read(path).each do |row|
        if last_key == 'INPUT'
          @input = row[0]
        elsif last_key == 'OUTPUT'
          @output = row[0]
        elsif last_key == 'ICON_PATH'
          @icon_path = row[0]
        elsif last_key == 'ICONS'
          @icons = {}
          current_control = 'ICONS'
        elsif last_key == 'COLORS'
          @colors = {}
          current_control = 'COLORS'
        end

        if current_control == 'ICONS'
          if row.empty?
            current_control = nil
          else
            @icons[row[0]] = {
              'icon' => row[1],
              'meaning' => row[2], 
              'name' => row[3] 
            }
          end
        elsif current_control == 'COLORS'
          if row.empty?
            current_control = nil
          else
            @colors[row[0]] = row[1]
          end
        end

        last_key = row[0]
      end
    end

    %w(icon_path icons colors input output).each do |name|
      define_singleton_method(name.to_sym) do
        instance_variable_get("@#{name}")
      end
    end

  end
end
