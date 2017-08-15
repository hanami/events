module Hanami
  module Events
    # Matcher for event names.
    #
    # Allows to match event names as patterns:
    # *         - match all events
    # user.*    - match all evensts started on user.
    # *.created - match all evensts ended on .created
    #
    # @since 0.1.0
    #
    # @api private
    class Matcher
      MATCH_ALL_CHARS = '.*'
      RANGE_PATTERN = '*'

      def initialize(pattern)
        @pattern = Regexp.new(to_regexp_string(pattern))
      end

      def match?(event_name)
        !!@pattern.match(event_name)
      end

      private

      def to_regexp_string(pattern)
        pattern.split('.')
          .map { |p| p == RANGE_PATTERN ? MATCH_ALL_CHARS : Regexp.escape(p) }
          .join('\.')
      end
    end
  end
end
