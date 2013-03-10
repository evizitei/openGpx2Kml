module TF1Converter::Kml
  class TrackColor
    def self.next
      if config.use_constant_color
        config.constant_color
      else
        @colors ||= config.colors.values
        @color_index ||= 0
        return_color = @colors[@color_index]
        @color_index += 1
        if @color_index >= @colors.length
          @color_index = 0
        end
        return_color
      end
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
