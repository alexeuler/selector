db_namespace=namespace :db do

  def establish_master_connection
    ActiveRecord::Base.clear_active_connections!
    ActiveRecord::Bas.establish_connection adapter: App.config.db.adapter,
                                            host: App.config.db.host,
                                            database: "postgres",
                                            username: App.config.db.user,
                                            password: App.config.db.password,
                                            'schema_search_path' => 'public'
  end

  def establish_db_connection
    ActiveRecord::Base.clear_active_connections!
    ActiveRecord::Base.establish_connection(
        adapter: App.config.db.adapter,
        host: App.config.db.host,
        database: App.config.db.name,
        username: App.config.db.user,
        password: App.config.db.password,
        reaping_frequency: 10,
        pool: 5
    )
  end


  task :environment do
    establish_db_connection
    ActiveRecord::Migrator.migrations_paths=
        File.expand_path("../crawler/models/migrations", File.dirname(__FILE__))
  end

  desc "create database"
  task :create do
    establish_master_connection
    ActiveRecord::Base.connection.create_database App::config.db.name
  end

  desc "drop database"
  task :drop do
    establish_master_connection
    ActiveRecord::Base.connection.drop_database App::config.db.name
  end

  desc "reset database"
  task :reset => ['db:drop', 'db:create', 'db:migrate']

  desc "runs pending migrations"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
    db_namespace['dump'].invoke
  end

  desc "rolls back the last migraion"
  task :rollback => :environment do
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, 1)
    db_namespace['dump'].invoke
  end

  task :dump => :environment do
    require 'active_record/schema_dumper'
    filename = File.join(ActiveRecord::Migrator.migrations_paths, 'schema.rb')
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
    db_namespace['dump'].reenable
  end

  desc "creates the migration specified by arg"
  task :migration, [:name] => [:environment] do |task, args|
    file_name = "#{ActiveRecord::Migrator.migrations_paths[0]}/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{args.name}.rb"
    file=File.new(file_name, "w")
    file.puts("class #{args.name.split('_').each { |s| s.capitalize! }.join('')} < ActiveRecord::Migration")
    file.puts("  def change")
    file.puts
    file.puts("  end")
    file.puts("end")
    file.close
  end
end
