require 'action_view'
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

      attr_reader :report

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        @io = ensure_io(path_or_io, 'html')
        @path_to_erb = File.join(File.dirname(__FILE__), '..', 'templates')
        @step_mother = step_mother
        @options = options
        @report = Report.new
        @img_id = 0
      end

      def embed(src, mime_type, label)
        case(mime_type)
        when /^image\/(png|gi|jpg|jpeg)/
          embed_image(src, label)
        end
      end

      def embed_image(src, label)
        @report.current_scenario.image = src.split('/').last
        @report.current_scenario.image_label = label
        @report.current_scenario.image_id = "img_#{@img_id}"
        @img_id += 1
        FileUtils.cp src, "#{File.dirname(@path)}/images"
      end

      def before_features(features)
        make_output_directories
        @tests_started = Time.now
      end

      def features_summary_file
        parts = @io.path.split('/')
        parts[parts.length - 1]
      end

      def before_feature(feature)
        @report.add_feature ReportFeature.new(feature, features_summary_file)
      end

      def after_feature(feature)
        @report.current_feature.close(feature)
      end

      def before_background(background)
        @report.begin_background
      end

      def after_background(background)
        @report.end_background
        @report.current_feature.background << ReportStep.new(background)
      end

      def before_feature_element(feature_element)
        unless scenario_outline? feature_element
          @report.add_scenario  ReportScenario.new(feature_element)
        end
      end

      def after_feature_element(feature_element)
        unless scenario_outline?(feature_element)
          process_scenario(feature_element)
        end
      end

      def before_table_row(example_row)
        @report.add_scenario ReportScenario.new(example_row) unless info_row?(example_row)
      end

      def after_table_row(example_row)
        unless info_row?(example_row)
          @report.current_scenario.populate(example_row)
          build_scenario_outline_steps(example_row)
        end
        populate_cells(example_row) if example_row.instance_of? Cucumber::Ast::Table::Cells
      end

      def before_step(step)
        @step_timer = Time.now
      end

      def after_step(step)
        step = process_step(step) unless step_belongs_to_outline? step
        if @cells
          step.table = @cells
          @cells = nil
        end
      end

      def after_features(features)
        @features = features
        @duration = format_duration(Time.now - @tests_started)
        generate_report
        copy_images_directory
        copy_stylesheets_directory
      end

      def features
        @report.features
      end

      private

      def generate_report
<<<<<<< HEAD
        renderer = ActionView::Base.new(@path_to_erb)
        filename = File.join(@path_to_erb, 'main')
        @io.puts renderer.render(:file => filename, :locals => {:report => self})
        features.each do |feature|
          write_feature_file(feature)
        end
      end

      def write_feature_file(feature)
        renderer = ActionView::Base.new(@path_to_erb)
        filename = File.join(@path_to_erb, 'feature')
        file = File.open("#{File.dirname(@path)}/#{feature.file}", Cucumber.file_mode('w'))
        file.puts renderer.render(:file => filename, :locals => {:feature => feature})
=======
        path_to_erb = File.join(File.dirname(__FILE__), '..', 'templates')
        filename = File.join(path_to_erb, 'main.erb')
        text = File.new(filename).read
        viewer = ActionView::Base.new(path_to_erb)
        @io.puts ERB.new(text, nil, "%>").result(binding)
        erbfile = File.join(path_to_erb, 'feature')
        features.each do |feature|
          write_feature_file(feature, viewer, erbfile)
        end
      end

      def write_feature_file(feature, viewer, filename)
        html = viewer.render(:file => filename, :locals => {:feature => feature})
        file = File.open("#{File.dirname(@path)}/#{feature.file}", Cucumber.file_mode('w'))
        file.puts html
>>>>>>> merge upstream changes
        file.flush
        file.close
      end

      def make_output_directories
        make_directory 'images'
        make_directory 'stylesheets'
      end

      def make_directory(dir)
        path = "#{File.dirname(@path)}/#{dir}"
        FileUtils.mkdir path unless File.directory? path
      end

      def copy_directory(dir, file_names, file_extension)
        path = "#{File.dirname(@path)}/#{dir}"
        file_names.each do |file|
          FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', "#{file}.#{file_extension}"), path
        end
      end

      def copy_images_directory
        copy_directory 'images', %w(face failed passed pending undefined skipped), "jpg"
      end

      def copy_stylesheets_directory
        copy_directory 'stylesheets', ['style'], 'css'
      end

      def process_scenario(scenario)
        @report.current_scenario.populate(scenario)
      end

      def process_step(step, status=nil)
        duration =  Time.now - @step_timer
        report_step = ReportStep.new(step)
        report_step.duration = duration
        report_step.status = status unless status.nil?
        if step.background?
          @report.current_feature.background << report_step if @report.processing_background_steps?
        else
          @report.add_step report_step
        end
        report_step
      end

      def scenario_outline?(feature_element)
        feature_element.is_a? Cucumber::Ast::ScenarioOutline
      end

      def info_row?(example_row)
        return example_row.scenario_outline.nil? if example_row.respond_to? :scenario_outline
        return true if example_row.instance_of? Cucumber::Ast::Table::Cells
        false
      end

      def step_belongs_to_outline?(step)
        scenario = step.instance_variable_get "@feature_element"
        not scenario.nil?
      end

      def build_scenario_outline_steps(example_row)
        values = example_row.to_hash
        steps = example_row.scenario_outline.raw_steps.clone
        steps.each do |step|
          name = nil
          values.each do |key, value|
            name = step.name.gsub("<#{key}>", "'#{value}'") if step.name.include? "<#{key}>"
          end
          current_step = process_step(step, example_row.status)
          current_step.name = name if name
          current_step.error = step_error(example_row.exception, step)
        end
      end

      def step_error(exception, step)
        return nil if exception.nil?
        exception.backtrace[-1] =~ /^#{step.file_colon_line}/ ? exception : nil
      end

      def populate_cells(example_row)
        @cells ||= []
        values = []
        example_row.to_a.each do |cell|
          values << cell.value
        end
        @cells << values
      end
    end
  end
end
