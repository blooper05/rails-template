# frozen_string_literal: true

### bullet ###
insert_into_file 'config/environments/test.rb', <<-CODE, before: /^end\Z/

  ### Bullet ###
  Bullet.enable        = true
  Bullet.bullet_logger = true
  Bullet.raise         = true
CODE

insert_into_file 'spec/rails_helper.rb', <<-CODE, before: /^end\Z/

  ### Bullet ###
  config.before(:each) { Bullet.start_request }
  config.after(:each) { Bullet.end_request }
CODE

### annotate ###
generate 'annotate:install'

### rails-erd ###
create_file '.erdconfig', <<~CODE
  attributes:
    - foreign_keys
    - primary_keys
    - timestamps
    - inheritance
    - content
  filetype: png
  sort: false
  exclude:
    - ActiveRecord::InternalMetadata
    - ActiveRecord::SchemaMigration
CODE
