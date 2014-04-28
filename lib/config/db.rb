require 'active_record'
ActiveRecord::Base.establish_connection(
    adapter: App.config.db.adapter,
    host: App.config.db.host,
    database: App.config.db.name,
    username: App.config.db.user,
    password: App.config.db.password,
    reaping_frequency: 10,
    pool: 5
)