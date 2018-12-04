# frozen_string_literal: true

### Gemfile ###
remove_file 'Gemfile.lock'
create_file 'Gemfile', <<~CODE, force: true
  source 'https://rubygems.org'

  ruby File.read('.ruby-version').strip

  ### Rails ###
  gem 'rails'
  gem 'puma'
  gem 'puma_worker_killer'

  ### Database ###
  gem 'pg'
  gem 'bcrypt'
  gem 'aasm'
  gem 'counter_culture'
  gem 'enumerize'
  gem 'active_type'
  gem 'seed-fu'

  ### API ###
  gem 'rack-cors'
  gem 'fast_jsonapi'
  gem 'versionist'
  gem 'oj'
  gem 'oj_mimic_json'
  gem 'knock'
  gem 'pagy'

  ### CLI ###
  gem 'thor'
  gem 'formatador'
  gem 'whenever'

  ### Monitoring ###
  gem 'komachi_heartbeat'
  gem 'sentry-raven'
  gem 'newrelic_rpm'
  gem 'ltsv_log_formatter'
  gem 'chrono_logger'

  group :development, :test do
    ### Console ###
    gem 'pry-rails'
    gem 'pry-coolline'
    gem 'hirb'
    gem 'awesome_print'
    gem 'pry-byebug'

    ### Analysis ###
    gem 'brakeman'
    gem 'bullet'
    gem 'snip_snip'

    ### Command ###
    gem 'spring'
    gem 'spring-commands-rspec'
    gem 'spring-commands-rubocop'
  end

  group :test do
    ### Testing ###
    gem 'rspec-rails'
    gem 'rspec-request_describer'
    gem 'factory_bot_rails'
    gem 'timecop'
    gem 'database_rewinder'
    gem 'fuubar'
    gem 'simplecov'
  end

  group :development do
    ### Analysis ###
    gem 'rubocop'
    gem 'rails_best_practices'
    gem 'reek'
    gem 'flay'
    gem 'fasterer'

    ### Utility ###
    gem 'annotate'
    gem 'rails-erd'
    gem 'prmd'
    gem 'jdoc'
    gem 'terminal-notifier'
  end

  group :deployment do
    ### Deployment ###
    gem 'capistrano'
    gem 'capistrano-rbenv'
    gem 'capistrano-bundler'
    gem 'capistrano-rails'
    gem 'capistrano3-unicorn'
    gem 'capistrano-rails-console'
    gem 'slackistrano'
  end
CODE

### bundle install ###
Bundler.with_clean_env do
  run 'bundle install --path vendor/bundle --binstubs .bundle/bin --jobs 4 --without production'
end
