require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'

module PrettyFace
  module Formatter
    class Html
      include Cucumber::Formatter::Io
      include Cucumber::Formatter::Duration

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        @io = ensure_io(path_or_io, 'html')
        @step_mother = step_mother
        @options = options
        @scenario_count = 0
        @passing_scenarios = 0
        @failing_scenarios = 0
        @passing_steps = 0
        @failing_steps = 0
        @skipped_steps = 0
        @step_times = []
        @scenario_times = []
      end

      def before_features(features)
        @tests_started = Time.now
      end

      def before_feature_element(feature_element)
        @scenario_timer = Time.now
      end

      def after_feature_element(feature_element)
        process_feature(feature_element)
      end 

      def before_step(step)
        @step_timer = Time.now
      end

      def after_step(step)
        process_step(step)
      end

      def after_features(features)
        @features = features
        @duration = format_duration(Time.now - @tests_started)
        generate_report
        copy_images_directory
      end

      def start_time
        @tests_started.strftime("%a %B %-d, %Y at %H:%M:%S")
      end

      def features
        @features
      end

      def step_count
        @step_times.size
      end

      def scenario_count
        @scenario_times.size
      end

      def total_duration
        @duration
      end

      def step_average_duration
        format_duration get_average_from_float_array @step_times
      end

      def scenario_average_duration
        format_duration get_average_from_float_array @scenario_times
      end

      def passing_scenarios
        "#{@passing_scenarios} (#{(@passing_scenarios.to_f / scenario_count) * 100}%)"
      end

      def failing_scenarios
        "#{@failing_scenarios} (#{(@failing_scenarios.to_f / scenario_count) * 100}%)"
      end

      def passing_steps
        "#{@passing_steps} (#{(@passing_steps.to_f / step_count) * 100}%)"
      end

      def failing_steps
        "#{@failing_steps} (#{(@failing_steps.to_f / step_count) * 100}%)"
      end

      private

      def generate_report
        filename = File.join(File.dirname(__FILE__), '..', 'templates', 'main.erb')
        text = File.new(filename).read
        @io.puts ERB.new(text, nil, "%").result(binding)
      end

      def copy_images_directory
        path = "#{File.dirname(@path)}/images"
        FileUtils.mkdir path unless File.directory? path
        FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', 'face.jpg'), path
      end

      def process_feature(feature_element)
        @passing_scenarios += 1 if feature_element.status == :passed
        @failing_scenarios += 1 if feature_element.status == :failed
        @scenario_times.push Time.now - @scenario_timer
      end

      def process_step(step)
        @passing_steps += 1 if step.status == :passed
        @failing_steps += 1 if step.status == :failed
        @skipped_steps += 1 if step.status == :skipped
        @step_times.push Time.now - @step_timer
      end

      def get_average_from_float_array (arr)
        arr.reduce(:+).to_f / arr.size
      end

    end
  end
end
