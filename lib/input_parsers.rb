# frozen_string_literal: true

module InputParsers
  module Datetime

    RU_FORMAT = "%d.%m.%Y %H:%M"
    US_FORMAT = "%m/%d/%Y %l:%M %p"

    def self.call(value)
      return nil if value.blank?
      begin
        DateTime.strptime(value, RU_FORMAT)
      rescue ArgumentError
        DateTime.strptime(value, US_FORMAT)
      end
    end

  end
end
