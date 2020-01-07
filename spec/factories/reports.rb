FactoryBot.define do
  factory :report do
    reason { Faker::Lorem.characters(number: 20) }
    body { Faker::Lorem.characters(number: 50) }
  end

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
