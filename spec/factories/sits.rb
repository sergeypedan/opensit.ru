FactoryBot.define do
  factory :sit do
    body { "I done a meditate." }
    s_type { "meditation" }
    duration { 30 }

    trait :journal do
      s_type { "diary" }
      title { "Making factories" }
      duration { nil }
    end

    trait :belongs_to_user do
      association :user, factory: :user
    end

    trait :private do
      visibility { 'private' }
    end

    trait :public do
      visibility { 'public' }
    end

    trait :one_hour_ago do
      created_at { 1.hours.ago }
    end

    trait :two_hours_ago do
      created_at { 2.hours.ago }
    end

    trait :three_hours_ago do
      created_at { 3.hours.ago }
    end

    trait :one_year_ago do
      created_at { 1.years.ago }
    end

  end
end

# == Schema Information
#
# Table name: sits
#
#  id               :integer          not null, primary key
#  body             :text
#  disable_comments :boolean          default(FALSE), not null
#  duration         :integer
#  s_type           :string           default("meditation"), not null
#  title            :string
#  views            :integer          default(0)
#  visibility       :enum             default("public")
#  user_id          :integer
#
