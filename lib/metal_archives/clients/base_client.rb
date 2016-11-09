module MetalArchives
##
# Clients are responsible for retrieving sources and assembling a model.
#
module Clients # :nodoc:
  ##
  # Base client class all client are derived from
  #
  class BaseClient # :nodoc:
    attr_accessor :query

    ##
    # Instantiate a client
    #
    def initialize(query)
      @query = query
    end
  end
end
end
