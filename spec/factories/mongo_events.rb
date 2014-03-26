FactoryGirl.define do
  factory :mongo_event do
    event_collection { build(:event_collection) }
  end

  factory :model3d_loaded, class: "MongoEvent" do
    event_collection { build(:event_collection) }
    sequence(:data) { |n| {
                            name: "my_model_#{n}",
                            polygon_number: rand(50),
                            times: {
                              download: rand(50),
                              load: rand(10)
                            },
                            size: rand(200)
                          }
                    }
  end
end
