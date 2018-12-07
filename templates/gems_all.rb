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

### puma ###
append_file 'config/puma.rb', <<~'CODE'

  ### Puma ###
  APP_PATH = File.expand_path('..', __dir__)
  PRD_FLAG = (ENV.fetch('RAILS_ENV') == 'production')

  if PRD_FLAG
    pidfile "#{APP_PATH}/tmp/pids/server.pid"
    bind    "unix://#{APP_PATH}/tmp/sockets/server.sock"

    daemonize true
  end
CODE

comment_lines 'config/puma.rb', 'port        ENV.fetch\("PORT"\) { 3000 }'
uncomment_lines 'config/puma.rb', 'workers ENV.fetch\("WEB_CONCURRENCY"\) { 2 }'
uncomment_lines 'config/puma.rb', 'preload_app!$'

### puma_worker_killer ###
append_file 'config/puma.rb', <<~'CODE'

  ### Puma Worker Killer ###
  before_fork do
    require 'puma_worker_killer'

    PumaWorkerKiller.config do |config|
      config.ram                       = 1024 # megabytes # FIXME
      config.frequency                 = 30   # seconds
      config.percent_usage             = 0.65
      config.rolling_restart_frequency = 6.hours
    end

    PumaWorkerKiller.start
  end
CODE

### rack-cors ###
append_file 'config/initializers/cors.rb', <<~CODE

  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '' # FIXME
      resource '*', headers: :any,
                    methods: %i[get post put patch delete options head]
    end
  end
CODE

### seed-fu ###
create_file 'db/fixtures/.keep'
remove_file 'db/seeds.rb'

### versionist ###
lib 'generators/versionist/new_api_version/new_api_version_generator.rb', <<~'CODE'
  module SerializedVersionist
    def add_routes
      super
      gsub_file 'config/routes.rb', /api_version\(.+\) do\n\s+end/ do |match|
        match.sub('end', "end\n")
      end end
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

generate 'versionist:new_api_version v1 V1 --path=value:v1'

### knock ###
generate 'knock:install'

### swagger-blocks ###
create_file 'app/controllers/concerns/swagger/.keep'
create_file 'app/models/concerns/swagger/.keep'

### swagger_ui_engine ###
initializer 'swagger_ui_engine.rb', <<~CODE
  def api_doc?
    defined?(SwaggerUiEngine)
  end

  return unless api_doc?
CODE

route "mount SwaggerUiEngine::Engine => '/api/doc' if api_doc?\n\n"

### whenever ###
run 'wheneverize .'

### komachi_heartbeat ###
route "mount KomachiHeartbeat::Engine => '/'"

### sentry-raven ###
initializer 'sentry.rb', <<~CODE
  Raven.configure do |config|
    config.dsn = '' # FIXME: Rails.application.credentials.sentry.dsn

    config.environments = %w[edge staging production]

    config.sanitize_fields =
      Rails.application.config.filter_parameters.map(&:to_s)
  end
CODE

### newrelic_rpm ###
run "newrelic install #{@app_name}"

### ltsv_log_formatter ###
insert_into_file 'config/environments/production.rb', <<-'CODE', before: /^end\Z/

  ### LtsvLogFormatter ###
  config.log_formatter = LtsvLogFormatter.new
CODE

### chrono_logger ###
insert_into_file 'config/environments/production.rb', <<-'CODE', before: /^end\Z/

  ### ChronoLogger ###
  config.logger = ::ChronoLogger.new("#{config.paths['log'].first}.%Y%m%d")
CODE
