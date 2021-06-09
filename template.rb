# frozen_string_literal: true

def source_paths
  [File.expand_path('./templates', __dir__)]
end

template 'Gemfile', force: true
