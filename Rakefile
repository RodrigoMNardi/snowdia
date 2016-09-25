require 'active_record'
require 'sqlite3'

namespace :db do
  db_config       = {adapter:  'sqlite3',
                     database: 'database/snowdia.db'}
  desc 'Create the database'
  task :create do
    puts "==> DB: #{db_config[:database]}"
    ActiveRecord::Base.establish_connection.create_database(db_config[:database])
    puts 'Database created.'
  end

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.migrate('database/migrations/')
    Rake::Task['db:schema'].invoke
    puts 'Database migrated.'
  end

  desc 'Drop the database'
  task :drop do
    ActiveRecord::Base.connection.drop_database(db_config[:database])
    puts 'Database deleted.'
  end

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = 'database/schema.rb'
    File.open(filename, 'w:utf-8') do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc 'Reset the database'
  task :reset => [:drop, :create, :migrate]
end
