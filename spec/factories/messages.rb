FactoryBot.define do
  factory :message do
    body { Faker::Lorem.paragraph(sentence_count: 1) }
    sequence :from_user_id do |n|
      1 + n
    end
    sequence :to_user_id do |n|
      2 + n
    end

    trait :read do
      read { true }
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  body             :text
#  read             :boolean          default(FALSE)
#  receiver_deleted :boolean          default(FALSE)
#  sender_deleted   :boolean          default(FALSE)
#  subject          :string
#  from_user_id     :integer
#  to_user_id       :integer
#
