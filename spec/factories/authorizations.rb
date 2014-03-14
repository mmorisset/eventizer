# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :authorization do
    sequence(:name) { |n| "Authorization #{n}" }
    access "read"
    user { build(:user) }
  end
  factory :master_authorization, class: "Authorization" do
    sequence(:name) { |n| "Authorization #{n}" }
    access "master"
    user { build(:user) }
  end
  factory :write_authorization, class: "Authorization" do
    sequence(:name) { |n| "Authorization #{n}" }
    access "write"
    user { build(:user) }
  end
  factory :read_authorization, class: "Authorization" do
    sequence(:name) { |n| "Authorization #{n}" }
    access "read"
    user { build(:user) }
  end
end
