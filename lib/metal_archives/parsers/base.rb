# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Abstract base class
    #
    class Base
      def self.parse(_input)
        raise NotImplementedError, "method .parse not implemented"
      end
    end
  end
end
