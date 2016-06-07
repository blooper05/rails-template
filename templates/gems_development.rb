### bullet ###
insert_into_file 'config/environments/test.rb', <<-CODE, before: /^end$/

  ### Bullet ###
  Bullet.enable        = true
  Bullet.bullet_logger = true
  Bullet.raise         = true
CODE

insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end$/

  ### Bullet ###
  config.before(:each) { Bullet.start_request }
  config.after(:each) { Bullet.end_request }
CODE

### annotate ###
generate 'annotate:install'

annotate_file = 'lib/tasks/auto_annotate_models.rake'
gsub_file annotate_file, /'routes'\s+=>\s+'false'/ do |match|
  match.sub('false', 'true')
end

### letter_opener ###
insert_into_file 'config/environments/development.rb', <<-CODE, before: /^end$/

  ### Letter Opener ###
  config.action_mailer.delivery_method = :letter_opener
CODE
