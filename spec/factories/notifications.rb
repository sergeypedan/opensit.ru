FactoryBot.define do
  factory :notification do
    message { Faker::Lorem.sentence(word_count: 10) }
    sequence :user_id do |n|
      n
    end

  end
end

# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  initiator   :integer
#  link        :string
#  message     :string
#  object_type :string
#  viewed      :boolean          default(FALSE)
#  object_id   :integer
#  user_id     :integer
#
