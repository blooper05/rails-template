# frozen_string_literal: true

### spring ###
run 'spring binstub --all'

### rubocop ###
COPS = %w[
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
].freeze

run "rubocop -a --only #{COPS.join(',')}"

### git init ###
after_bundle do
  remove_file '.git'
  remove_file 'template.rb'
  remove_file 'templates'

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
