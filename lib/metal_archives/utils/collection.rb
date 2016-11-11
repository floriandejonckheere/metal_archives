module MetalArchives
  ##
  # Enumerable collection over a paginated resource
  #
  class Collection
    include Enumerable

    def initialize(proc)
      @proc = proc
    end

    def each(&block)
      return to_enum :each unless block_given?

      loop do
        items = instance_exec &@proc

        items.each do |item|
          yield item
        end

        break if items.empty?
      end
    end
  end
end
