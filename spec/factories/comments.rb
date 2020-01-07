FactoryBot.define do
  factory :comment do
    user
    sit
    body { "lol, yeah, you're enlightened now!!1" }
  end
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  sit_id     :integer
#  user_id    :integer
#
