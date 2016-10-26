TEMPLATES_PATH = "#{File.dirname(__FILE__)}/templates".freeze

apply "#{TEMPLATES_PATH}/gemfile.rb"
apply "#{TEMPLATES_PATH}/rails.rb"
apply "#{TEMPLATES_PATH}/gems_all.rb"
apply "#{TEMPLATES_PATH}/gems_development_test.rb"
apply "#{TEMPLATES_PATH}/gems_test.rb"
apply "#{TEMPLATES_PATH}/gems_development.rb"
apply "#{TEMPLATES_PATH}/gems_deployment.rb"
apply "#{TEMPLATES_PATH}/project.rb"
