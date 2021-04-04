# frozen_string_literal: true

module MetalArchives
  ##
  # Abstract model class
  #
  class Base
    include Attributable
    include Cacheable
    include Initializable

    ##
    # Fetch, parse and load the data
    #
    # [Raises]
    # - rdoc-ref:Errors::InvalidIDError when no id
    # - rdoc-ref:Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def load!
      raise Errors::InvalidIDError, "no id present" unless id

      # Use constructor to set attributes
      set(**assemble)

      @loaded = true
      cache!
    rescue StandardError => e
      # Don't cache invalid requests
      evict!

      raise e
    end

    ##
    # Whether or not the object is currently loaded
    #
    def loaded?
      @loaded ||= false
    end

    ##
    # String representation
    #
    def inspect
      "#<#{self.class.name} @id=#{@id} @name=\"#{@name}\">"
    end

    protected

    ##
    # Fetch the data and assemble the model
    #
    # Override this method
    #
    # [Raises]
    # - rdoc-ref:Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def assemble
      raise Errors::NotImplementedError, "method :assemble not implemented"
    end
  end
end
