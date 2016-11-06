module MetalArchives
##
# Clients are responsible for retrieving sources and assembling a model.
#
module Clients # :nodoc:
  ##
  # Base client class all client are derived from
  #
  class BaseClient # :nodoc:
    attr_accessor :query, :parser

    ##
    # Instantiate a client
    #
    def initialize(query)
      @query = query
    end

    protected
      def http
        MetalArchives::HTTPClient.client
      end

      def parser
        @parser ||= MetalArchives::Parsers.const_get self.class.name.split('::').last
      rescue NameError
        raise MetalArchives::Error, "No parser for class #{self.class.name}"
      end

      def model
        @model ||= MetalArchives.const_get self.class.name.split('::').last
      rescue NameError
        raise MetalArchives::Error, "No model for class #{self.class.name}"
      end
  end
end
end
