# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    user_id 1
    info "MyString"
    status 1
  end
end
