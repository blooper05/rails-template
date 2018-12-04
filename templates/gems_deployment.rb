# frozen_string_literal: true

### capistrano ###
run 'cap install STAGES=edge,staging,production'
create_file 'lib/capistrano/tasks/.keep'

### capistrano-rbenv ###
uncomment_lines 'Capfile', 'require "capistrano/rbenv"'

### capistrano-bundler ###
uncomment_lines 'Capfile', 'require "capistrano/bundler"'

### capistrano-rails ###
uncomment_lines 'Capfile', 'require "capistrano/rails/migrations"'

### seed-fu ###
insert_into_file 'Capfile', "require 'seed-fu/capistrano3'\n",
                 before: "\n# Load custom tasks from `lib/capistrano/tasks`"

### whenever ###
insert_into_file 'Capfile', "require 'whenever/capistrano'\n",
                 before: "\n# Load custom tasks from `lib/capistrano/tasks`"

### capistrano-rails-console ###
insert_into_file 'Capfile', "require 'capistrano/rails/console'\n",
                 before: "\n# Load custom tasks from `lib/capistrano/tasks`"

### slackistrano ###
insert_into_file 'Capfile', "require 'slackistrano/capistrano'\n",
                 before: "\n# Load custom tasks from `lib/capistrano/tasks`"
