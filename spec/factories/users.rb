FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password "password"
    authentication_token nil
    # confirmed_at { Time.now }
  end
end
