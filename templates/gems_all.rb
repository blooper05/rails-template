# frozen_string_literal: true

### pg ###
append_file 'config/database.yml', <<~CODE
    host:     <%= ENV['#{@app_name.upcase}_DATABASE_HOST'] %>
  edge:
    <<: *default
    database: #{app_name}_edge
    username: #{app_name}
    password: <%= ENV['#{@app_name.upcase}_DATABASE_PASSWORD'] %>
    host:     <%= ENV['#{@app_name.upcase}_DATABASE_HOST'] %>
  staging:
    <<: *default
    database: #{app_name}_staging
    username: #{app_name}
    password: <%= ENV['#{@app_name.upcase}_DATABASE_PASSWORD'] %>
    host:     <%= ENV['#{@app_name.upcase}_DATABASE_HOST'] %>
CODE

### rack-cors ###
initializer 'rack-cors.rb', <<~CODE
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '' # FIXME
      resource '*', headers: :any,
                    methods: %i[get post put patch delete options head]
    end
  end
CODE

### versionist ###
lib 'generators/versionist/new_api_version/new_api_version_generator.rb', <<~'CODE'
  module SerializedVersionist
    def add_routes
      super
      gsub_file 'config/routes.rb', /api_version\(.+\) do\n\s+end/ do |match|
        match.sub('end', "end\n")
      end
    end

    def add_presenters_base
      in_root do
        create_file "app/serializers/#{module_name_for_path(module_name)}/.keep"
      end
    end

    def add_presenter_test
      in_root do
        create_file "spec/serializers/#{module_name_for_path(module_name)}/.keep"
      end
    end

    def add_helpers_dir
      in_root do
        create_file "app/helpers/#{module_name_for_path(module_name)}/.keep"
      end
    end

    def add_helpers_test_dir
      in_root do
        create_file "spec/helpers/#{module_name_for_path(module_name)}/.keep"
      end
    end

    def add_documentation_base
    end
  end

  class Versionist::NewApiVersionGenerator
    prepend SerializedVersionist
  end
CODE

generate 'versionist:new_api_version v1 V1 --path=value:v1 --default'

### seed-fu ###
create_file 'db/fixtures/.keep'
remove_file 'db/seeds.rb'

### whenever ###
run 'wheneverize .'

### komachi_heartbeat ###
route "mount KomachiHeartbeat::Engine => '/healthcheck'\n\n"

### chrono_logger ###
insert_into_file 'config/environments/production.rb', <<-'CODE', before: /^end\Z/

  ### ChronoLogger ###
  config.logger = ::ChronoLogger.new("#{config.paths['log'].first}.%Y%m%d")
CODE
