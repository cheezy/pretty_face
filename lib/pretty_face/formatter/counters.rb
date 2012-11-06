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
    end
  end
end

