require_dependency 'history_tracker.rb' if Rails.env == "development"
# config/initializers/mongoid-audit.rb
# initializer for mongoid-audit
# assuming HistoryTracker is your tracker class
Mongoid::Audit.tracker_class_name = :history_tracker

# config/initializers/mongoid-audit.rb
# initializer for mongoid-audit
# assuming you're using devise/authlogic
Mongoid::Audit.current_user_method = :current_user