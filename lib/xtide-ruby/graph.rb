module Tide

  class Graph
    attr_accessor :location, :events, :series

    def initialize(params = {})
      params.each do |i,v|
        self.send("#{i}=".to_sym, v)
      end
    end

    def self.by_location(name, year, month, day)
      if Graph.is_day_of_month(year, month, day)
        begin_time = Time.local(year, month, day)
        end_time = begin_time + (24 * 60 * 60 * 5) + 2

        location = Location.find_by_name(name)
        events = Event.by_location(name, begin_time, end_time)

        tz = TZInfo::Timezone.get(location.time_zone)
        b = tz.local_to_utc(begin_time)
        e = tz.local_to_utc(end_time)

        series = []

        Client::Command.raw_csv(name, b, e).each do |line|
          fields = line.split(",")
          x = fields[1].to_f
          y = fields[2].to_f
          point = Point.new(:x => x, :y => y)
          series << point
        end
        return Graph.new(:location => location, :events => events, :series => series)
      else
        raise "invalid date"
      end
    end

    private

    # check for valid date
    def self.is_day_of_month(year, month, day)

      if (month < 1) || (month > 12)
        return false
      end

      return (day > 0) && (day <= last_day_of_month(year, month))
    end

    # returns the last day of the month accounting for leap year
    def self.last_day_of_month(year, month)
      month_days = [nil,31,28,31,30,31,30,31,31,30,31,30,31]
      result = month_days[month]
      if is_leap_year(year) && (month == 2)
        result += 1
      end
      return result
    end

    # returns true for leap year, false otherwise
    def self.is_leap_year(year)
      return (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) ? true : false
    end

  end

end
