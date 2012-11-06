module PrettyFace
  module Formatter
    module Counters

      def passed_scenarios
        @passed_scenarios ||= 0
      end

      def failed_scenarios
        @failed_scenarios ||= 0
      end

      def skipped_scenarios
        @skipped_scenarios ||= 0
      end

      def pending_scenarios
        @pending_scenarios ||= 0
      end

      def undefined_scenarios
        @undefined_scenarios ||= 0
      end

      def passed_steps
        @passed_steps ||= 0
      end

      def failed_steps
        @failed_steps ||= 0
      end

      def skipped_steps
        @skipped_steps ||= 0
      end

      def pending_steps
        @pending_steps ||= 0
      end

      def undefined_steps
        @undefined_steps ||= 0
      end
    end
  end
end

