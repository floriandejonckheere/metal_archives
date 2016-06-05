module MetalArchives
  class Error < StandardError; end

  class InvalidConfigurationError < Error; end
  class ParserError < Error; end
  class NotImplementedError < Error; end

  class APIError < Error; end
end
