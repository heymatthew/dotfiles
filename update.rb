#!/usr/bin/env ruby

def platform
  case RUBY_PLATFORM
  when /darwin/i
    "darwin"
  else
    "unknown"
  end
end

require_relative "./update/#{platform}.rb"
