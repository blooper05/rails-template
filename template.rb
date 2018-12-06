# frozen_string_literal: true

PATH = "#{File.dirname(__FILE__)}/templates"

FILES = %w[
  gemfile
  rails
  gems_all
  gems_development_test
  gems_test
  gems_development
  project
].freeze

FILES.each { |file| apply "#{PATH}/#{file}.rb" }
