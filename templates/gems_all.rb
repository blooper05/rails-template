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

### unicorn ###
UNICORN_CONF_URL = 'http://unicorn.bogomips.org/examples/unicorn.conf.rb'.freeze

inside 'config/unicorn' do
  run "curl -s #{UNICORN_CONF_URL} -o production.rb"
  run 'ln -s production.rb edge.rb'
  run 'ln -s production.rb staging.rb'
end

### unicorn-worker-killer ###
prepend_file 'config.ru', <<~CODE
  # Unicorn self-process killer
  require 'unicorn/worker_killer'

  # Max requests per worker
  max_request_min = (ENV['UNICORN_MAX_REQUEST_MIN'] || 3072).to_i
  max_request_max = (ENV['UNICORN_MAX_REQUEST_MAX'] || 4096).to_i
  use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

  # Max memory size (RSS) per worker
  oom_min = (ENV['UNICORN_OOM_MIN'] || 192).to_i * (1024**2)
  oom_max = (ENV['UNICORN_OOM_MAX'] || 256).to_i * (1024**2)
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max

CODE

### active_model_serializers ###
create_file 'app/serializers/.keep'
create_file 'app/serializers/concerns/.keep'
create_file 'spec/serializers/.keep'

### versionist ###
initializer 'versionist.rb', <<~'CODE'
  module SerializedVersionist
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

### oj ###
initializer 'oj.rb', <<~CODE
  # attempts to be compatible with other systems
  Oj.default_options = { mode: :compat }
CODE

### kaminari ###
generate 'kaminari:config'

### seed-fu ###
create_file 'db/fixtures/.keep'

### config ###
generate 'config:install'
create_file 'config/settings/edge.yml'
create_file 'config/settings/staging.yml'
remove_file 'config/settings.local.yml'

### dotenv-rails ###
create_file '.env'

### whenever ###
run 'wheneverize .'

### komachi_heartbeat ###
route "mount KomachiHeartbeat::Engine => '/healthcheck'\n"

### chrono_logger ###
gsub_file 'config/environments/production.rb', /# config\.logger = .+/ do
  'config.logger = ::ChronoLogger.new("#{config.paths[:log][0]}.%Y%m%d")'
end

### exception_notification ###
initializer 'exception_notification.rb', <<~CODE
  require 'exception_notification/rails'

  ExceptionNotification.configure do |config|
    # do not notify in development env and test env
    config.ignore_if do
      Rails.env.development? || Rails.env.test?
    end

    # notification to Slack
    config.add_notifier(
      :slack, webhook_url: Settings.slack.webhook_url,
              channel:     Settings.slack.channel,
              username:    Settings.slack.username,
              additional_parameters: { icon_emoji: Settings.slack.icon },
              http_options: { proxy_address: Settings.proxy.address,
                              proxy_port:    Settings.proxy.port }
    )
  end
CODE

%w(development edge production staging test).each do |env|
  append_file "config/settings/#{env}.yml", <<~CODE
    proxy:
      address: ''
      port:    ''

    slack:
      webhook_url: ''
      channel:     ''
      username:    ''
      icon:        ''
  CODE
end
