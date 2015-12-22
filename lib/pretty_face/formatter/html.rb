require 'action_view'
require 'fileutils'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/core/ast/scenario'
require 'cucumber/multiline_argument/data_table'

require File.join(File.dirname(__FILE__), 'view_helper')
require File.join(File.dirname(__FILE__), 'report')

# Starting with ActionPack 4.1.1, the module Mime doesn't get initialized before it's needed by PrettyFace and so
# it would blow up with errors about uninitialized constants. We need to explicitly load it to prevent this problem.
require 'action_dispatch/http/mime_type'

module PrettyFace
  module Formatter

    class Html
      include Cucumber::Formatter::Io
      include Cucumber::Formatter::Duration
      include ViewHelper

      attr_reader :report, :logo

      def initialize(step_mother, path_or_io, options)
        @path = path_or_io
        set_path_and_file(path_or_io)
        @path_to_erb = File.join(File.dirname(__FILE__), '..', 'templates')
        @step_mother = step_mother
        @options = options
        # The expand option is set to true by RubyMine and cannot be turned off using the IDE. This option causes
        # a test run while using this gem to terminate.
        @options[:expand] = false unless @options.nil?
        @report = Report.new
        @img_id = 0
        @logo = 'face.png'
      end

      def set_path_and_file(path_or_io)
        return if path_or_io.nil?
        dir = File.dirname(path_or_io)
        FileUtils.mkdir_p dir unless File.directory? dir
        @io = ensure_io(path_or_io)
      end
      
      def embed(src, mime_type, label)
        case(mime_type)
        when /^image\/(png|gif|jpg|jpeg)/
          embed_image(src, label)
        end
      end

      def embed_image(src, label)
        @report.current_scenario.image << src.split(separator).last
        @report.current_scenario.image_label << label
        @report.current_scenario.image_id << "img_#{@img_id}"
        @img_id += 1
        filename = "#{File.dirname(@path)}#{separator}images"
        FileUtils.cp src, filename
      end

      def before_features(features)
        make_output_directories
        @tests_started = Time.now
      end

      def features_summary_file
        parts = @io.path.split(separator)
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
        @report.add_scenario  ReportScenario.new(feature_element)
      end

      def after_feature_element(feature_element)
        process_scenario(feature_element)
      end

      def before_table_row(example_row)
        @before_example_row = example_row
        @report.add_scenario ReportScenario.new(example_row) unless info_row?(example_row)
      end

      def after_table_row(example_row)
        unless info_row?(example_row)
          @report.current_scenario.populate(example_row)
          build_scenario_outline_steps(example_row)
        end
        populate_cells(example_row) if example_row.instance_of? Cucumber::Core::Ast::DataTable
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
        copy_images
        copy_stylesheets
        generate_report
      end

      def features
        @report.features
      end

      def custom_suite_header?
        return false unless customization_directory

        Dir.foreach(customization_directory) do |file|
          return true if file == '_suite_header.erb'
        end
        false
      end

      def custom_feature_header?
        return false unless customization_directory

        Dir.foreach(customization_directory) do |file|
          return true if file == '_feature_header.erb'
        end
        false
      end

      private

      def generate_report
        paths = [@path_to_erb, customization_directory.to_s]
        renderer = ActionView::Base.new(paths)
        filename = File.join(@path_to_erb, 'main')
        @io.puts renderer.render(:file => filename, :locals => {:report => self, :logo => @logo})
        features.each do |feature|
          write_feature_file(feature)
        end
      end

      def write_feature_file(feature)
        paths = [@path_to_erb, customization_directory.to_s]
        renderer = ActionView::Base.new(paths)
        filename = File.join(@path_to_erb, 'feature')
        output_file = "#{File.dirname(@path)}#{separator}#{feature.file}"
        to_cut = output_file.split(separator).last
        directory = output_file.sub("#{separator}#{to_cut}", '')
        FileUtils.mkdir_p directory unless File.directory? directory
        file = File.new(output_file, Cucumber.file_mode('w'))
        file.puts renderer.render(:file => filename, :locals => {:feature => feature, :logo => @logo, :customize => custom_feature_header?})
        file.flush
        file.close
      end

      def make_output_directories
        make_directory 'images'
        make_directory 'stylesheets'
      end

      def make_directory(dir)
        path = "#{File.dirname(@path)}#{separator}#{dir}"
        FileUtils.mkdir_p path unless File.directory? path
      end

      def copy_directory(dir, file_names, file_extension)
        path = "#{File.dirname(@path)}#{separator}#{dir}"
        file_names.each do |file|
          copy_file File.join(File.dirname(__FILE__), '..', 'templates', "#{file}.#{file_extension}"), path
        end
      end

      def copy_file(source, destination)
        FileUtils.cp source, destination
      end

      def copy_images
        copy_directory 'images', %w(failed passed pending undefined skipped table_failed table_passed table_pending table_undefined table_skipped), "png"
        logo = logo_file
        copy_file logo, "#{File.join(File.dirname(@path), 'images')}" if logo
        copy_directory 'images', ['face'], 'png' unless logo
      end

      def copy_stylesheets
        copy_directory 'stylesheets', ['style'], 'css'
      end

      def logo_file
        dir = customization_directory
        Dir.foreach(dir) do |file|
          if file =~ /^logo\.(png|gif|jpg|jpeg)$/
            @logo = file
            return File.join(dir, file)
          end
        end if dir
      end

      def customization_directory
        dir = File.join(File.expand_path('features'), 'support', 'pretty_face')
        return dir if File.exists? dir
      end

      def process_scenario(scenario)
        @report.current_scenario.populate(scenario)
      end

      def process_step(step, status=nil)
        duration =  Time.now - @step_timer
        report_step = ReportStep.new(step)
        report_step.duration = duration
        report_step.status = status unless status.nil?
        if step.background
          @report.current_feature.background << report_step if @report.processing_background_steps?
        else
          @report.add_step report_step
        end
        report_step
      end

      def scenario_outline?(feature_element)
        feature_element.is_a? Cucumber::Core::Ast::ScenarioOutline
      end

      def info_row?(example_row)
        return example_row.scenario_outline.nil? if example_row.respond_to? :scenario_outline
        return true if example_row.instance_of? Cucumber::Formatter::LegacyApi::Ast::DataTableRow
        false
      end

      def step_belongs_to_outline?(step)
        scenario = step.instance_variable_get "@feature_element"
        not scenario.nil?
      end

      def build_scenario_outline_steps(example_row)
        si = example_row.cells
        si.each do |row|
          duration =  Time.now - @step_timer
          report_step = ReportStep.new(@before_example_row, example_row)
          report_step.duration = duration
          @report.add_step report_step
#          process_step(row, row.status)
        end
      end

      def step_error(exception)
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

      def separator
        File::ALT_SEPARATOR || File::SEPARATOR
      end
    end
  end
end
