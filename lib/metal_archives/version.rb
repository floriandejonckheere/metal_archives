# frozen_string_literal: true

module MetalArchives
  ##
  # MetalArchives API version
  #
  module Version
    MAJOR = 3
    MINOR = 1
    PATCH = 0
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  VERSION = Version::STRING
end
