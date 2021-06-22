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

# === spring ===
run 'spring binstub --all'
