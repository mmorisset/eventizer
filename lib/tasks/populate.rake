require 'factory_girl_rails'
 
namespace :db do
  desc "Populate the database"
  task :populate, [:count] do |t, args|
    puts "Resetting the database"
    Rake::Task['db:drop'].invoke

    p 'Create the default user'
    user = FactoryGirl.create(:user, email: 'admin@eventizer.com', password: 'password')

    p 'Create the default authorization'
    authorization = FactoryGirl.create(:write_authorization, secret: 'test', user: user)

    p 'Create a default project'
    project = FactoryGirl.create(:project, name: 'default_project', user: user)

    p 'Create a default collection'
    collection = FactoryGirl.create(:event_collection, name: 'default_collection', project: project.id)

    p 'Creating mongo events'
    for i in 1..args[:count].to_i
      puts "Creating mongo event number: #{i}"
      FactoryGirl.create(:model3d_loaded, event_collection: collection)
    end
    puts "Done!"
  end
end