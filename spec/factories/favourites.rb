FactoryBot.define do
  factory :favourite do
    sequence :user_id do |n|
      n
    end
    sequence :favourable_id do |n|
      n
    end
    favourable_type { "Sit" }

  end
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
