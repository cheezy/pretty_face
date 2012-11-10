require 'cucumber/ast/scenario_outline'

module PrettyFace
  module Formatter
    module ViewHelper

      def start_time
        @tests_started.strftime("%a %B %-d, %Y at %H:%M:%S")
      end

      def step_count
        @step_mother.steps.length
      end

      def scenario_count
        @step_mother.scenarios.length
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

      def scenarios_summary_for(status)
        summary_percent(@step_mother.scenarios(status).length, scenario_count)
      end

      def passed_steps_summary
        summary_percent(passed_steps, step_count)
      end

      def failed_steps_summary
        summary_percent(failed_steps, step_count)
      end

      def skipped_steps_summary
        summary_percent(skipped_steps, step_count)
      end

      def pending_steps_summary
        summary_percent(pending_steps, step_count)
      end

      def undefined_steps_summary
        summary_percent(undefined_steps, step_count)
      end

      def failed_scenario?(scenario)
        scenario.status == :failed
      end

      def image_tag_for(scenario)
        status = scenario.status.to_s
        "<img src=\"images/#{status}.jpg\" alt=\"#{status}\" title=\"#{status}\" width=\"30\""
      end

      private

      def get_average_from_float_array (arr)
        arr.reduce(:+).to_f / arr.size
      end

      def summary_percent(number, total)
        percent = (number.to_f / total) * 100
        "#{number} (#{'%.1f' % percent}%)"
      end
    end
  end
end
