require 'erb'
require 'cucumber/formatter/io'

module PrettyFace
  module Formatter
    class Html
      include Cucumber::Formatter::Io

      def initialize(step_mother, path_or_io, options)
        puts "path or io is #{path_or_io}"
        @io = ensure_io(path_or_io, 'html')
        puts "io is #{@io}"
        @step_mother = step_mother
        @options = options
      end

      def before_features(features)
        puts "feature is #{features}"
      end
    end
  end
end
