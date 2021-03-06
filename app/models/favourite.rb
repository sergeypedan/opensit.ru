class Favourite < ActiveRecord::Base

  # attr_accessor :user_id, :favourable_type, :favourable_id

  belongs_to :user
  belongs_to :favourable, polymorphic: true

  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :favourable_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :favourable_type, presence: true

end

# == Schema Information
#
# Table name: favourites
#
#  id              :integer          not null, primary key
#  favourable_type :string
#  favourable_id   :integer
#  user_id         :integer
#
