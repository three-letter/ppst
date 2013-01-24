# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cast do
    user
    title { "Cast #{Cast.count}" }
    price 1
    free_time 10
  end
end
