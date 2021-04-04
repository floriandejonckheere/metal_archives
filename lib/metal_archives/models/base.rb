# frozen_string_literal: true

module MetalArchives
  ##
  # Abstract model class
  #
  class Base
    include Attributable
    include Cacheable
    include Initializable
    include Loadable
    include Queryable

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
    # - rdoc-ref:Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def assemble
      raise Errors::NotImplementedError, "method :assemble not implemented"
    end
  end
end
