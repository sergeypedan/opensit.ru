class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favourable, polymorphic: true

  validates_presence_of :user_id, :favourable_id, :favourable_type
  attr_accessible :user_id, :favourable_type, :favourable_id
end

# == Schema Information
#
# Table name: favourites
#
#  id              :integer          not null, primary key
#  favourable_id   :integer
#  favourable_type :string
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#
