class Tag < ActiveRecord::Base

  attr_accessible :name

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
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime         not null
#
