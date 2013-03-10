module TF1Converter::Kml
  class TrackColor
    def self.next
      @colors ||= ::TF1Converter::Config.colors.values
      @color_index ||= 0
      return_color = @colors[@color_index]
      @color_index += 1
      if @color_index >= @colors.length
        @color_index = 0
      end
      return_color
    end
  end
end
