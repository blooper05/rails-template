### spring ###
run 'spring binstub --all'

### rubocop ###
COPS = %w(
  Lint/UnusedBlockArgument
  Style/AndOr
  Style/DefWithParentheses
  Style/EmptyLineBetweenDefs
  Style/EmptyLines
  Style/EmptyLinesAroundAccessModifier
  Style/EmptyLinesAroundBlockBody
  Style/EmptyLinesAroundClassBody
  Style/EmptyLinesAroundMethodBody
  Style/EmptyLinesAroundModuleBody
  Style/ExtraSpacing
  Style/HashSyntax
  Style/IndentationConsistency
  Style/IndentationWidth
  Style/MethodCallParentheses
  Style/MethodDefParentheses
  Style/MultilineOperationIndentation
  Style/SpaceAfterColon
  Style/SpaceAfterComma
  Style/SpaceAfterNot
  Style/SpaceAfterSemicolon
  Style/SpaceAroundEqualsInParameterDefault
  Style/SpaceAroundOperators
  Style/SpaceBeforeSemicolon
  Style/SpaceInsideHashLiteralBraces
  Style/StringLiterals
  Style/TrailingBlankLines
  Style/TrailingWhitespace
).freeze

run "rubocop -a --only #{COPS.join(',')}"

### .gitignore ###
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

### git init ###
after_bundle do
  remove_file '.git'
  remove_file 'template.rb'
  remove_file 'templates'

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
