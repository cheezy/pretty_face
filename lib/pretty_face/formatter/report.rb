module PrettyFace
  module Formatter

    module Formatting
      def summary_percent(number, total)
        percent = (number.to_f / total) * 100
        "#{number} (#{'%.1f' % percent}%)"
      end

      def formatted_duration
        m, s = duration.divmod(60)
        "#{m}m#{'%.3f' % s}s" 
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
      def begin_background(background)
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

      attr_accessor :scenarios, :background
      attr_reader :title, :file, :start_time, :duration

      def initialize(feature)
        self.scenarios = []
        @start_time = Time.now
      end

      def close(feature)
        @title = feature.title
        @duration = Time.now - start_time
        a_file = feature.file.sub(/\.feature/, '.html')
        @file = a_file.split('/').last
      end

      def steps
        steps = []
        scenarios.each { |scenario| steps += scenario.steps }
        steps
      end

      def scenario_summary_for(status)
        scenarios_with_status = scenarios.find_all { |scenario| scenario.status == status }
        summary_percent(scenarios_with_status.length, scenarios.length)
      end

      def step_summary_for(status)
        steps_with_status = steps.find_all { |step| step.status == status }
        summary_percent(steps_with_status.length, steps.length)
      end

      def get_binding
        binding
      end
    end

    class ReportScenario
      attr_accessor :name, :file_colon_line, :status, :steps

      def initialize(scenario)
        self.steps = []
      end

      def populate(scenario)
        if scenario.instance_of? Cucumber::Ast::Scenario
          self.name = scenario.name
          self.file_colon_line = scenario.file_colon_line
        elsif scenario.instance_of? Cucumber::Ast::OutlineTable::ExampleRow
          self.name = scenario.scenario_outline.name
          self.file_colon_line = scenario.backtrace_line
        end
        self.status = scenario.status
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
  end
end
