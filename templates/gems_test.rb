# frozen_string_literal: true

### rspec-rails ###
generate 'rspec:install'

comment_lines 'spec/rails_helper.rb', 'config\.fixture_path'
uncomment_lines 'spec/rails_helper.rb', 'spec/support/\*\*/\*\.rb'

create_file 'spec/jobs/.keep'
create_file 'spec/models/.keep'
create_file 'spec/support/utilities.rb'

### rspec-request_describer ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end$/

  ### RSpec::RequestDescriber ###
  config.include RSpec::RequestDescriber, type: :request
CODE

### factory_bot_rails ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end$/

  ### Factory Bot ###
  config.before(:suite) { FactoryBot.reload }
  config.include FactoryBot::Syntax::Methods
CODE

### timecop ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end$/

  ### timecop ###
  config.after(:each) { Timecop.return }
CODE

### database_rewinder ###
insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end$/

  ### DatabaseRewinder ###
  config.before(:suite) { DatabaseRewinder.clean_all }
  config.after { DatabaseRewinder.clean }
CODE

### fuubar ###
comment_lines '.gitignore', '.rspec'
append_file '.rspec', '--format Fuubar'

### simplecov ###
insert_into_file 'spec/rails_helper.rb', "\n\nrequire 'simplecov'",
                 after: /^# Add additional requires below this line.+$/

create_file '.simplecov', <<~CODE
  SimpleCov.start 'rails'

  # vim: set ft=ruby:
CODE
