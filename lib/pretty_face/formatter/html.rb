require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/ast/scenario'
require 'cucumber/ast/table'
require 'cucumber/ast/outline_table'
require File.join(File.dirname(__FILE__), 'view_helper')

module PrettyFace
  module Formatter

    class Report
      attr_reader :features

      def initialize
        @features = []
      end

      def add(feature)
        @features << feature
      end

      def current_feature
        @features.last
      end
    end

    class ReportFeature
      attr_accessor :title, :scenarios
      def initialize(feature)
        self.title = feature.title
        self.scenarios = []
      end

      def add_scenario(scenario)
        @scenarios << scenario
      end

      def current_scenario
        @scenarios.last
      end
    end

    class ReportScenario
      attr_accessor :name, :file_colon_line, :status, :steps
      def initialize(scenario)
        if scenario.instance_of? Cucumber::Ast::Scenario
          self.name = scenario.name
          self.file_colon_line = scenario.file_colon_line
        elsif scenario.instance_of? Cucumber::Ast::OutlineTable::ExampleRow
          self.name = scenario.scenario_outline.name
          self.file_colon_line = scenario.backtrace_line
        end
        self.status = scenario.status
        self.steps = []
      end
    end

    class ReportStep
      attr_accessor :name, :file_colon_line, :status
      def initialize(step)
          self.name = step.name
          self.file_colon_line = step.file_colon_line
          self.status = step.status
      end
    end

    class Html
      include Cucumber::Formatter::Io
      include Cucumber::Formatter::Duration
      include ViewHelper

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        @io = ensure_io(path_or_io, 'html')
        @step_mother = step_mother
        @options = options
        @report = Report.new
        @step_times = []
        @scenario_times = []
        @current_steps = []
      end

      def before_features(features)
        @tests_started = Time.now
      end

      def before_feature(feature)
        feature = ReportFeature.new(feature)
        @report.add feature
      end

      def before_feature_element(feature_element)
        @scenario_timer = Time.now
      end

      def after_feature_element(feature_element)
        unless scenario_outline?(feature_element)
          process_scenario(feature_element)
        end
      end

      def after_outline_table(outline_table)
        process_scenario_outline(outline_table)
      end

      def after_table_row(example_row)
        @scenario_times.push Time.now - @scenario_timer
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
        @report.features
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
        @scenario_times.push Time.now - @scenario_timer
      end

      def process_scenario(scenario)
        @scenario_times.push Time.now - @scenario_timer
        the_scenario = ReportScenario.new(scenario)
        the_scenario.steps = @current_steps
        @report.current_feature.add_scenario the_scenario
        @current_steps = []
      end

      def process_example_row(example_row)
        the_scenario = ReportScenario.new(example_row)
        the_scenario.steps = @current_steps
        @report.current_feature.add_scenario the_scenario
      end

      def process_scenario_outline(scenario_outline)
        scenario_outline.example_rows.each do |example_row|
          process_example_row(example_row)
        end
        @current_steps = []
      end

      def process_step(step)
        @step_times.push Time.now - @step_timer
        @current_steps.push ReportStep.new(step)
      end

      def scenario_outline?(feature_element)
        feature_element.is_a? Cucumber::Ast::ScenarioOutline
      end
    end
  end
end
