class Tag < ActiveRecord::Base

  has_many :taggings
	has_many :sits, through: :taggings

  class << self

    def parse_CSV(csv)
      return [] if csv.blank?
      csv.split(",")
         .map(&:squish)
         .reject(&:blank?)
         .map(&:downcase)
         .map { |token| Tag.find_or_create_by(name: token) }
    end

  end

end

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#
