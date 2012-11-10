module PrettyFace
  module Formatter
    module Counters

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

