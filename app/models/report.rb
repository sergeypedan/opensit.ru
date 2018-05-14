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
#  id              :bigint(8)        not null, primary key
#  reportable_type :string
#  reportable_id   :bigint(8)
#  user_id         :bigint(8)
#  reason          :string
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
