FactoryBot.define do
  factory :user do
    sequence :username do |n|
      "#{Faker::Name.first_name}#{n}"
    end
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 12) }

    factory :buddha do
      username { "buddha" }
    end

    factory :ananda do
      username { "ananda" }
    end

    trait :has_first_name do
      first_name { Faker::Name.first_name }
    end

    trait :no_first_name do
      first_name { nil }
    end

    trait :has_last_name do
      last_name { Faker::Name.last_name }
    end

    trait :no_last_name do
      last_name { nil }
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  authentication_token   :string
#  avatar_content_type    :string
#  avatar_file_name       :string
#  avatar_file_size       :bigint
#  city                   :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  country                :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  default_sit_length     :integer          default(30)
#  dob                    :date
#  email                  :string
#  encrypted_password     :string(128)      default(""), not null
#  failed_attempts        :integer          default(0)
#  first_name             :string
#  gender                 :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  password_salt          :string
#  practice               :text
#  private_diary          :boolean
#  private_stream         :boolean          default(FALSE)
#  remember_token         :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0)
#  sits_count             :integer          default(0)
#  streak                 :integer          default(0)
#  style                  :string(100)
#  unlock_token           :string
#  user_type              :integer
#  username               :string
#  website                :string(100)
#  who                    :text
#  why                    :text
#
