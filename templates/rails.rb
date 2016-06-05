### README.md ###
create_file 'README.md', "# #{app_name}"
remove_file 'README.rdoc'

### config/environments ###
inside 'config/environments' do
  run 'ln -s production.rb edge.rb'
  run 'ln -s production.rb staging.rb'
end

### config/initializers/secret_token.rb ###
remove_file 'config/initializers/secret_token.rb'

### config/locales ###
create_file 'config/locales/en.yml', force: true
create_file 'config/locales/ja.yml'

### config/application.rb ###
application do
  <<-CODE.lstrip
    ### Generators ###
    config.generators do |g|
      g.test_framework :rspec
    end

    ### TimeZone ###
    config.time_zone                      = 'Tokyo'
    config.active_record.default_timezone = :local

    ### Locale ###
    config.i18n.default_locale = :ja
  CODE
end

### config/routes.rb ###
gsub_file 'config/routes.rb', /^\s*#.*\n/, ''

### config/secrets.yml ###
comment_lines '.gitignore', 'config/secrets.yml'
append_file 'config/secrets.yml', <<~CODE

  edge:
    secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>

  staging:
    secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
CODE
