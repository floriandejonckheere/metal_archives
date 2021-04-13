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
  end
end
