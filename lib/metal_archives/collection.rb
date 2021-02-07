# frozen_string_literal: true

module MetalArchives
  ##
  # Enumerable collection over a paginated resource
  #
  class Collection
    include Enumerable

    ##
    # Construct a new Collection
    #
    # [+proc+]
    #   +Proc+ or +lambda+, called repeatedly when iterating. Should return an array of results (stateful),
    #   should return an empty array when there are no results left.
    #
    def initialize(proc)
      @proc = proc
    end

    ##
    # Calls the given block once for each element, passing that element as a parameter.
    # If no block is given, an Enumerator is returned.
    #
    def each(&block)
      return to_enum :each unless block

      loop do
        items = instance_exec(&@proc)

        items.each(&block)

        break if items.empty?
      end
    end

    def empty?
      first.nil?
    end
  end
end
