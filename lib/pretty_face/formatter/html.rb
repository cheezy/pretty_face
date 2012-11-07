require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/ast/scenario_outline'
require File.join(File.dirname(__FILE__), 'counters')
require File.join(File.dirname(__FILE__), 'view_helper')

module PrettyFace
  module Formatter
    class Html
      include Cucumber::Formatter::Io
      include Cucumber::Formatter::Duration
      include ViewHelper
      include Counters

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        @io = ensure_io(path_or_io, 'html')
        @step_mother = step_mother
        @options = options
        @scenario_count = 0
        @step_times = []
        @scenario_times = []
        @scenario_count = 0
      end

      def before_features(features)
        @tests_started = Time.now
      end

      def before_feature_element(feature_element)
        @scenario_timer = Time.now
        if feature_element.instance_of? Cucumber::Ast::ScenarioOutline
          feature_element.each_example_row {|row| @scenario_count += 1}
        else
          @scenario_count += 1
        end
        
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

      def features
        @features
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
        %w(face failed passed pending undefined skipped).each do |file|
          FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', "#{file}.jpg"), path
        end
      end

      def process_feature(feature_element)
        unless feature_element.instance_of? Cucumber::Ast::ScenarioOutline
          value = self.send "#{feature_element.status}_scenarios"
          instance_variable_set "@#{feature_element.status}_scenarios", value+1
        end
        if feature_element.instance_of? Cucumber::Ast::ScenarioOutline
          feature_element.each_example_row do |row|
            value = self.send "#{row.status}_scenarios"
            instance_variable_set "@#{row.status}_scenarios", value+1
          end
        end
        @scenario_times.push Time.now - @scenario_timer
      end

      def process_step(step)
        value = self.send "#{step.status}_steps"
        instance_variable_set "@#{step.status}_steps", value+1
        @step_times.push Time.now - @step_timer
      end

    end
  end
end
