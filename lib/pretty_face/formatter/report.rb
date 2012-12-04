module PrettyFace
  module Formatter

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

      def add_step(step)
        current_scenario.steps << step
      end
    end

    class ReportFeature
      attr_accessor :scenarios
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
