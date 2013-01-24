# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { "user_#{User.count + 1}" } 
    pwd { "password_#{User.count + 1}" }
    pwd_confirmation { "password_#{User.count + 1}" }
    avatar { fixture_file_upload( Rails.root.join('apps','assets','avatar_small.jpg'), 'image/jpg') }
  end
end
