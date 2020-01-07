class Report < ActiveRecord::Base

  belongs_to :reportable
  belongs_to :user

  validates :body, presence: true
  validates :reason, presence: true
  validates :reportable_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reportable_type, presence: true
  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }

end

# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  body            :text
#  reason          :string
#  reportable_type :string
#  reportable_id   :bigint
#  user_id         :bigint
#
