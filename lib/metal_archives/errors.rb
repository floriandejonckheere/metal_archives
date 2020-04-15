# frozen_string_literal: true

module MetalArchives
  ##
  # MetalArchives gem specific errors
  #
  module Errors
    ##
    # Generic error
    #
    class Error < StandardError; end

    ##
    # No or invalid ID
    #
    class InvalidIDError < Error; end

    ##
    # No or invalid configuration
    #
    class InvalidConfigurationError < Error; end

    ##
    # Error parsing value
    #
    class ParserError < Error; end

    ##
    # Functionality not implemented (yet)
    class NotImplementedError < Error; end

    ##
    # Error in backend response
    #
    class APIError < Error
      attr_reader :code,
                  :message

      def initialize(response)
        @code = response.code
        @message = "#{response.reason}: #{response.body}"
      end
    end

    ##
    # Error in method argument
    #
    class ArgumentError < Error; end

    ##
    # Incorrect type
    #
    class TypeError < Error; end
  end
end
