# frozen_string_literal: true

### rspec-rails ###
generate 'rspec:install'

comment_lines 'spec/rails_helper.rb', 'config\.fixture_path'
uncomment_lines 'spec/rails_helper.rb', 'spec/support/\*\*/\*\.rb'

create_file 'spec/jobs/.keep'
create_file 'spec/models/.keep'
create_file 'spec/support/utilities.rb'

### rspec-request_describer ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end\Z/

  ### RSpec::RequestDescriber ###
  config.include RSpec::RequestDescriber, type: :request
CODE

### factory_bot_rails ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end\Z/

  ### Factory Bot ###
  config.before(:suite) { FactoryBot.reload }
  config.include FactoryBot::Syntax::Methods
CODE

### timecop ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end\Z/

  ### timecop ###
  config.after(:each) { Timecop.return }
CODE

### database_rewinder ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end\Z/

  ### DatabaseRewinder ###
  config.before(:suite) { DatabaseRewinder.clean_all }
  config.after { DatabaseRewinder.clean }
CODE

### fuubar ###
append_file '.gitignore', "\n!.rspec\n"
append_file '.rspec', '--format Fuubar'

### simplecov-json ###
prepend_file 'spec/rails_helper.rb', <<~CODE
  require 'simplecov'
  require 'simplecov-json'

  SimpleCov.start :rails do
    formatter SimpleCov::Formatter::JSONFormatter if ENV['CIRCLECI']
  end

CODE
