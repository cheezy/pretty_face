require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/ast/scenario_outline'
require File.join(File.dirname(__FILE__), 'counters')
require File.join(File.dirname(__FILE__), 'view_helper')

module PrettyFace
  module Formatter
    class ReportFeature
      attr_accessor :title, :scenarios
      def initialize(feature)
        self.title = feature.title
      end
    end
    class ReportScenario
      attr_accessor :name, :file_colon_line, :status, :steps
      def initialize(scenario)
        if scenario.instance_of? Cucumber::Ast::Scenario
          self.name = scenario.name
          self.file_colon_line = scenario.file_colon_line
          self.status = scenario.status
        elsif scenario.instance_of? Cucumber::Ast::OutlineTable::ExampleRow
          self.name = scenario.name
          self.file_colon_line = scenario.backtrace_line
          self.status = scenario.status
        end
        self.steps = []
      end
    end
    class ReportStep
      attr_accessor :name, :file_colon_line, :status
      def initialize(step)
        unless step.nil?
          self.name = step.name
          self.file_colon_line = step.file_colon_line
          self.status = step.status
        end
      end
    end
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
        @passed_steps = @failed_steps = @skipped_steps = @pending_steps = @undefined_steps = 0
        @step_times = []
        @scenario_times = []
        @report_features = []
        @current_scenarios = []
        @current_steps = []
      end

      def before_features(features)
        @tests_started = Time.now
      end
      
      def before_feature(feature)
        @current_feature = ReportFeature.new(feature)
      end

      def after_feature(feature)
        @current_feature.scenarios = @current_scenarios
        @report_features.push @current_feature
        @current_scenarios = []
      end

      def before_feature_element(feature_element)
        @is_scenario_outline = feature_element.is_a? Cucumber::Ast::ScenarioOutline
        @scenario_timer = Time.now
      end

      def after_feature_element(feature_element)
        if not @is_scenario_outline
          process_scenario(feature_element)
        end
      end 

      def after_outline_table(outline_table)
        process_scenario_outline(outline_table)
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
        #@features
        @report_features
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
        @scenario_times.push Time.now - @scenario_timer
      end

      def process_scenario(scenario)
        value = self.send "#{scenario.status}_scenarios"
        instance_variable_set "@#{scenario.status}_scenarios", value+1

        @scenario_times.push Time.now - @scenario_timer

        @current_scenario = ReportScenario.new(scenario)
        @current_scenario.steps = @current_steps
        @current_scenarios.push @current_scenario
        @current_steps = []

      end

      def process_scenario_outline(scenario_outline)
        scenario_outline.example_rows.each do |example_row| 
          value = self.send "#{example_row.status}_scenarios"
          instance_variable_set "@#{example_row.status}_scenarios", value+1

          @current_scenario = ReportScenario.new(example_row)
          @current_scenario.steps = @current_steps
          @current_scenarios.push @current_scenario
          @current_steps = []

          # probably want to do this after each row
          @scenario_times.push Time.now - @scenario_timer
        end
      end

      def process_step(step)
        value = self.send "#{step.status}_steps"
        instance_variable_set "@#{step.status}_steps", value+1
        @step_times.push Time.now - @step_timer

        @current_step = ReportStep.new(step)
        @current_steps.push @current_step
      end

    end
  end
end
