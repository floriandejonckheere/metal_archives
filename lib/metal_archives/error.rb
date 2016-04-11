module MetalArchives
  class Error < StandardError; end

  class InvalidConfigurationError < Error; end
  class InvalidIdError < Error; end

  class NotImplementedError < Error; end
end
