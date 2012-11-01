require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'

module PrettyFace
  module Formatter
    class Html
      include Cucumber::Formatter::Io

      attr_reader :features, :scenario_count, :step_count, :scenario_average, :step_average

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        @io = ensure_io(path_or_io, 'html')
        @step_mother = step_mother
        @options = options
        @scenario_count = 0
        @step_times = []
        @scenario_times = []
      end

      def before_feature_element(feature_element)
        @scenario_timer = Time.now
      end

      def after_feature_element(feature_element)
        process_feature
      end 

      def before_step(step)
        @step_timer = Time.now
      end

      def after_step(step)
        process_step
      end

      def after_features(features)
        @features = features
        copy_images_directory
        generate_report
      end

      private

      def generate_report
        filename = File.join(File.dirname(__FILE__), '..', 'templates', 'main.erb')
        text = File.new(filename).read
        renderer = ERB.new(text, nil, "%")
        @io.puts renderer.result(binding)
      end

      def copy_images_directory
        dirname = File.dirname(@path)
        path = "#{dirname}/images"
        FileUtils.mkdir path unless File.directory? path
        FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', 'face.jpg'), path
      end

      def process_feature
        @scenario_times.push Time.now - @scenario_timer
        @scenario_average = @scenario_times.reduce(:+).to_f / @scenario_times.size
        @scenario_count = @scenario_times.size
      end

      def process_step
        @step_times.push Time.now - @step_timer
        @step_average = @step_times.reduce(:+).to_f / @step_times.size 

        # This will show hours, minutes, seconds, but when the avg is under a second, it just shows 00:00:00
        # @step_average = Time.at(@step_times.inject{ |sum, el| sum + el }.to_f / @step_times .size ).gmtime.strftime('%R:%S')

        @step_count = @step_times.size
      end
    end
  end
end
