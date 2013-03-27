module TF1Converter::Kml
  class TrackColor
    def self.next
      return_color = if config.use_constant_color
        config.constant_color
      else
        @colors ||= config.colors.values
        @color_index ||= 0
        rc = @colors[@color_index]
        @color_index += 1
        if @color_index >= @colors.length
          @color_index = 0
        end
        rc
      end
      return_color.rjust(8, '0')
    end

    def self.uncache!
      @colors = nil
      @color_index = nil
    end

    private
    def self.config
      ::TF1Converter::Config
    end
  end
end
