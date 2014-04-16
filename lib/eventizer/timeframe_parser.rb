class TimeframeParser

  def initialize()
  end

  def parse(timeframe)
    if match = /(previous|this)_(?:(\d)_|)(minute|hour|day|week|month|year)/.match(timeframe)
      result = Jbuilder.encode do |json|
        duration = match[2] || 1
        if match[1] == 'this'
          json.start_time eval "Time.now - #{duration}.#{match[3]}"
          json.end_time Time.now
        end
        if match[1] == 'previous'
          json.start_time eval "Time.now.beginning_of_#{match[3]} - #{duration}.#{match[3]}"
          json.end_time eval "Time.now.beginning_of_#{match[3]}"
        end
      end
    end
  end
end
