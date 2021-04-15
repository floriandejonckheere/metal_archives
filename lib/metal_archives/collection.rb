# frozen_string_literal: true

module MetalArchives
  ##
  # Enumerable collection over a paginated resource
  #
  class Collection
    include Enumerable

    class_attribute :class_name

    attr_reader :endpoint, :params, :cursor

    ##
    # Construct a new Collection
    #
    # [Params]
    # - +endpoint+: JSON endpoint
    # - +params+: Hash
    #
    def initialize(endpoint, params)
      @endpoint = endpoint
      @params = params

      @cursor = 0
    end

    def each
      return to_enum(:each) unless block_given?

      loop do
        break if cursor >= length

        json = JSON
          .parse(MetalArchives.http.get(endpoint, params.merge(iDisplayStart: cursor)))

        @length ||= json["iTotalRecords"].to_i

        json
          .fetch("aaData")
          .each do |data|
          url = Nokogiri::HTML(CGI.unescapeHTML(data.first))
            .at("a")
            .attr("href")

          id = Types::URI.cast(url).path.split("/").last.to_i

          yield class_name.find(id)
        end

        @cursor += json.count
      end
    end

    def length
      @length ||= JSON
        .parse(MetalArchives.http.get(endpoint, params))
        .fetch("iTotalRecords")
        .to_i
    end

    def empty?
      length.zero?
    end
  end

  def self.Collection(class_name)
    Class.new(Collection) do
      self.class_name = class_name
    end
  end
end
