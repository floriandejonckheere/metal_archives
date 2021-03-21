# frozen_string_literal: true

module MetalArchives
  ##
  # MetalArchives API version
  #
  module Version
    MAJOR = 3
    MINOR = 0
    PATCH = 2
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  VERSION = Version::STRING
end
