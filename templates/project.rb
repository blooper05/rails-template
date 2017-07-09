# frozen_string_literal: true

### spring ###
run 'spring binstub --all'

### rubocop ###
run 'rubocop --auto-correct'

### git init ###
after_bundle do
  remove_file '.git'
  remove_file 'template.rb'
  remove_file 'templates'

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
