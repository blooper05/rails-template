# .gitignore
GITIGNORE_IO_URL = 'https://www.gitignore.io/api/'.freeze

IGNORES = %w(
  ruby
  rails
  sublimetext
  vim
  jetbrains
  linux
  osx
  windows
).freeze

run "curl -s #{GITIGNORE_IO_URL + IGNORES.join('%2C')} > .gitignore"
