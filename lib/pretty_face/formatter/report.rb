module PrettyFace
  module Formatter

    module Formatting
      def summary_percent(number, total)
        percent = (number.to_f / total) * 100
        "#{number} <span class=\"percentage\">(#{'%.1f' % percent}%)</span>"
      end

      def formatted_duration(duration)
        m, s = duration.divmod(60)
        "#{m}m#{'%.3f' % s}s"
      rescue
        "N m Ns"
      end

      def image_tag_for(status, source=nil)
        dir = "#{directory_prefix_for(source)}images"
        "<img src=\"#{dir}/#{status}.png\" alt=\"#{status}\" title=\"#{status}\">"
      end

      def table_image_for(status, source=nil)
        dir = "#{directory_prefix_for(source)}images"
        "<img src=\"#{dir}/table_#{status}.png\" alt=\"#{status}\" title=\"#{status}\">"

      end

      def directory_prefix_for(source=nil)
        dir = ''
        back_dir = source.count(separator) if source
        back_dir.times do
          dir += "..#{separator}"
        end
        dir
      end

      def separator
        File::ALT_SEPARATOR || File::SEPARATOR
      end
    end


    class Report
      attr_reader :features

      def initialize
        @features = []
      end

      def current_feature
        @features.last
      end

      def current_scenario
        current_feature.scenarios.last
      end

      def add_feature(feature)
        @features << feature
      end

      def add_scenario(scenario)
        current_feature.scenarios << scenario
      end

      def begin_background
        @processing_background = true
      end

      def end_background
        @processing_background = false
      end

      def processing_background_steps?
        @processing_background
      end

      def add_step(step)
        current_scenario.steps << step
      end
    end

    class ReportFeature
      include Formatting
      attr_accessor :scenarios, :background, :description
      attr_reader :title, :file, :start_time, :duration, :parent_filename

      def initialize(feature, parent_filename)
        @scenarios = []
        @background = []
        @start_time = Time.now
        @description = feature.description
        @parent_filename = parent_filename
      end

      def close(feature)
        @title = feature.name
        @duration = Time.now - start_time
        a_file = feature.file.sub(/\.feature/, '.html')
        to_cut = a_file.split(separator).first
        @file = a_file.sub("#{to_cut}#{separator}", '')
      end

      def steps
        steps = []
        scenarios.each { |scenario| steps += scenario.steps }
        steps
      end

      def background_title
        title = @background.find { |step| step.keyword.nil? }
      end

      def background_steps
        @background.find_all { |step| step.keyword }
      end

      def scenarios_for(status)
        scenarios.find_all { |scenario| scenario.status == status }
      end

      def scenario_summary_for(status)
        scenarios_with_status = scenarios_for(status)
        summary_percent(scenarios_with_status.length, scenarios.length)
      end

      def step_summary_for(status)
        steps_with_status = steps.find_all { |step| step.status == status }
        summary_percent(steps_with_status.length, steps.length)
      end

      def scenario_average_duration
        has_duration = scenarios.reject { |scenario| scenario.duration.nil? }
        durations = has_duration.collect { |scenario| scenario.duration }
        formatted_duration(durations.reduce(:+).to_f / durations.size)
      end

      def step_average_duration
        steps = scenarios.collect { |scenario| scenario.steps }
        has_duration = steps.flatten.reject { |step| step.duration.nil? }
        durations = has_duration.collect { |step| step.duration }
        formatted_duration(durations.reduce(:+).to_f / durations.size)
      end

      def get_binding
        binding
      end

      def description?
        !description.nil?  && !description.empty?
      end

      def has_background?
        background.length > 0
      end

      def file
        @file.split("features#{separator}").last
      end

      def parent_filename
        @parent_filename.split(separator).last
      end
    end

    class ReportScenario
      attr_accessor :name, :file_colon_line, :status, :steps, :duration, :image, :image_label, :image_id

      def initialize(scenario)
        @steps = []
        @image = []
        @image_label = []
        @image_id = []
        @start = Time.now
      end
      
      def populate(scenario)
        @duration = Time.now - @start
        @status = scenario.status
        if scenario.instance_of? Cucumber::Formatter::LegacyApi::Ast::Scenario
          @name = scenario.name
          @file_colon_line = scenario.line
        elsif scenario.instance_of? Cucumber::Formatter::LegacyApi::Ast::ExampleTableRow
          @name = scenario.name
          @file_colon_line = scenario.line
        end
      end

      def has_image?
        not image.nil?
      end
    end

    class ReportStep
      attr_accessor :name, :keyword, :file_colon_line, :status, :duration, :table, :multiline_arg, :error

      def initialize(step, ast_step=nil)
        if ast_step
          @name = ast_step.name
          @keyword = ast_step.keyword
          @status = ast_step.status
          @error = ast_step.exception
        else
          @name = step.name
          unless step.instance_of? Cucumber::Formatter::LegacyApi::Ast::Background
            @keyword = step.keyword
            @status = step.status
            @multiline_arg = step.multiline_arg unless step.multiline_arg.instance_of? Cucumber::Core::Ast::EmptyMultilineArgument
            @error = step.exception
          end
        end
        @file_colon_line = step.file_colon_line
      end

      def failed_with_error?
        status == :failed && !error.nil?
      end

      def has_table?
        not table.nil?
      end

      def has_multiline_arg?
        !multiline_arg.nil? && !has_table?
      end

      def file_with_error(file_colon_line)
        @snippet_extractor ||= SnippetExtractor.new
        file, line = @snippet_extractor.file_name_and_line(file_colon_line)
        file
      end

      #from cucumber ===================
      def extra_failure_content(file_colon_line)
        @snippet_extractor ||= SnippetExtractor.new
        @snippet_extractor.snippet(file_colon_line)
      end

      class SnippetExtractor
        require 'syntax/convertors/html';
        @@converter = Syntax::Convertors::HTML.for_syntax "ruby"

        def file_name_and_line(error_line)
          if error_line =~ /(.*):(\d+)/
            [$1, $2.to_i]
          end
        end

        def snippet(error)
          raw_code, line, file = snippet_for(error[0])
          highlighted = @@converter.convert(raw_code, false)

          "<pre class=\"ruby\"><strong>#{file + "\n"}</strong><code>#{post_process(highlighted, line)}</code></pre>"
        end

        def snippet_for(error_line)
            file, line = file_name_and_line(error_line)
          if file
            [lines_around(file, line), line, file]
          else
            ["# Couldn't get snippet for #{error_line}", 1, 'File Unknown']
          end
        end

        def lines_around(file, line)
          if File.file?(file)
            # lines = File.open(file).read.split("\n")
            lines = File.readlines(file)
            min = [0, line-3].max
            max = [line+1, lines.length-1].min
            # lines[min..max].join("\n")
            lines[min..max].join
          else
            "# Couldn't get snippet for #{file}"
          end
        end

        def post_process(highlighted, offending_line)
          new_lines = []
          highlighted.split("\n").each_with_index do |line, i|
            new_line = "<span class=\"linenum\">#{offending_line+i-2}</span>#{line}"
            new_line = "<span class=\"offending\">#{new_line}</span>" if i == 2
            new_lines << new_line
          end
          new_lines.join("\n")
        end
      end
    end
  end
end
