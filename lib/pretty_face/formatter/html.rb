require 'erb'
require 'fileutils'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/ast/scenario'
require 'cucumber/ast/table'
require 'cucumber/ast/outline_table'
require File.join(File.dirname(__FILE__), 'view_helper')
require File.join(File.dirname(__FILE__), 'report')

module PrettyFace
  module Formatter

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
        @outline_steps = []
      end

      def before_features(features)
        @tests_started = Time.now
      end

      def before_feature(feature)
        @report.add_feature ReportFeature.new(feature)
      end

      def after_feature(feature)
        @report.current_feature.close(feature)
      end

      def before_feature_element(feature_element)
        @scenario_timer = Time.now
        unless scenario_outline? feature_element
          @report.add_scenario  ReportScenario.new(feature_element)
        end
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
        erbfile = File.join(File.dirname(__FILE__), '..', 'templates', 'feature.erb')
        text = File.new(erbfile).read
        features.each do |feature|
          write_feature_file(feature, text)
        end
      end

      def write_feature_file(feature, text)
          file = File.open("#{File.dirname(@path)}/#{feature.file}", Cucumber.file_mode('w'))
          file.puts ERB.new(text, nil, "%").result(feature.get_binding)
          file.flush
          file.close
      end

      def copy_images_directory
        path = "#{File.dirname(@path)}/images"
        FileUtils.mkdir path unless File.directory? path
        %w(face failed passed pending undefined skipped).each do |file|
          FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', "#{file}.jpg"), path
        end
      end

      def process_scenario(scenario)
        @scenario_times.push Time.now - @scenario_timer
        @report.current_scenario.populate(scenario)
      end

      def process_example_row(example_row)
        @report.add_scenario build_scenario_outline_with example_row
      end

      def process_scenario_outline(scenario_outline)
        scenario_outline.example_rows.each do |example_row|
          process_example_row(example_row)
        end
        @outline_steps = []
      end

      def process_step(step)
        @step_times.push Time.now - @step_timer
        if step_belongs_to_outline? step
          @outline_steps << ReportStep.new(step)
        else
          @report.add_step ReportStep.new(step)
        end
      end

      def scenario_outline?(feature_element)
        feature_element.is_a? Cucumber::Ast::ScenarioOutline
      end

      def step_belongs_to_outline?(step)
        scenario = step.instance_variable_get "@feature_element"
        not scenario.nil?
      end

      def build_scenario_outline_with(example_row)
        scenario = ReportScenario.new(example_row)
        scenario.steps = @outline_steps
        scenario.populate example_row
        scenario
      end
    end
  end
end
