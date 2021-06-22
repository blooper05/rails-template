# frozen_string_literal: true

def source_paths
  [File.expand_path('./templates', __dir__)]
end

template 'Gemfile', force: true

application do
  <<~CODE
    # === Generators ===
    config.generators do |generator|
      generator.test_framework      :rspec
      generator.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # === TimeZone ===
    config.time_zone                      = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    # === Locale ===
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ja

  CODE
end

# === Locale ===
remove_file 'config/locales/en.yml'
copy_file 'config/locales/defaults/en.yml'
copy_file 'config/locales/defaults/ja.yml'
copy_file 'config/locales/models/.keep'

# === Routing ===
route 'draw :api'
copy_file 'config/routes/api.rb'

# === rspec-rails ===
generate 'rspec:install'
copy_file 'spec/factories/.keep'
copy_file 'spec/jobs/.keep'
copy_file 'spec/models/.keep'
copy_file 'spec/requests/.keep'
copy_file 'spec/support/.keep'

# === rspec-request_describer ===
insert_into_file 'spec/rails_helper.rb', <<~CODE, before: /^end\Z/

  # === rspec-request_describer ===
  config.include RSpec::RequestDescriber, type: :request
CODE

# === rubocop ===
copy_file '.rubocop.yml'

# === annotate ===
generate 'annotate:install'

# === rails-erd ===
generate 'erd:install'
copy_file '.erdconfig'

# === spring ===
run 'spring binstub --all'

# === rubocop ===
run 'rubocop --auto-correct-all --format simple'
