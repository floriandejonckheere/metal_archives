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
  # Error in data
  #
  class DataError < Error; end

  ##
  # No or invalid configuration found
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
  class APIError < Error; end
end
end
