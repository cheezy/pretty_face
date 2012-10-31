require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'

module PrettyFace
  module Formatter
    class Html
      include Cucumber::Formatter::Io

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        @io = ensure_io(path_or_io, 'html')
        @step_mother = step_mother
        @options = options
      end

      def after_features(features)
        images_directory
        filename = File.join(File.dirname(__FILE__), '..', 'templates', 'main.erb')
        text = File.new(filename).read
        renderer = ERB.new(text, nil, "%")
        @io.puts renderer.result
      end

      private

      def images_directory
        dirname = File.dirname(@path)
        path = "#{dirname}/images"
        FileUtils.mkdir path unless File.directory? path
        FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', 'face.jpg'), path
      end
    end
  end
end
