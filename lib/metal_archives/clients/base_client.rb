module MetalArchives
##
# Clients are responsible for retrieving sources and assembling a model.
#
module Clients # :nodoc:
  ##
  # Base client class all client are derived from
  #
  class BaseClient # :nodoc:
    def http
      MetalArchives::HTTPClient.client
    end

    ##
    # Resolve model parser
    #
    def parser
      MetalArchives::Parsers.const_get self.class.name.gsub('Client', '')
    rescue NameError => e
      raise MetalArchives::Error, "No parser found for client #{self.class.name}"
    end
  end
end
end
