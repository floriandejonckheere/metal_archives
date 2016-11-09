require 'date'
require 'countries'

module MetalArchives

  ##
  # Represents an band (person or group)
  #
  class Band < BaseModel
    ##
    # :attr_reader: id
    #
    # Returns +Integer+
    #
    property :id, :type => Integer

    ##
    # :attr_reader: name
    #
    # Returns +String+
    #
    property :name

    ##
    # :attr_reader: aliases
    #
    # Returns +Array+ of +String+
    #
    property :aliases, :multiple => true

    ##
    # :attr_reader: country
    #
    # Returns +ISO3166::Country+
    #
    property :country, :type => ISO3166::Country

    ##
    # :attr_reader: location
    #
    # Returns +String+
    #
    property :location

    ##
    # :attr_reader: date_formed
    #
    # Returns +Date+
    #
    property :date_formed, :type => Date

    ##
    # :attr_reader: date_active
    #
    # Returns +Array+ of rdoc-ref:Range
    #
    property :date_active, :type => MetalArchives::Range, :multiple => true

    ##
    # :attr_reader: genres
    #
    # Returns +Array+ of +String+
    #
    property :genres, :multiple => true

    ##
    # :attr_reader: lyrical_themes
    #
    # Returns +Array+ of +String+
    #
    property :lyrical_themes, :multiple => true

    ##
    # :attr_reader: label
    #
    # Returns rdoc-ref:Label
    #
    property :label, :type => MetalArchives::Label

    ##
    # :attr_reader: independent
    #
    # Returns boolean
    #
    enum :independent,  :values => [true, false]

    ##
    # :attr_reader: comment
    #
    # Returns +String+
    #
    property :comment

    ##
    # :attr_reader: status
    #
    # Returns +:active+, +:split_up+, +:on_hold+, +:unknown+, +:changed_name+ or +:disputed+
    #
    enum :status,       :values => [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]

    # TODO: releases
    # TODO: members
    # TODO: reviews
    # TODO: similar bands
    # TODO: links

    ##
    # :attr_reader: logo
    #
    # Returns +String+
    #
    property :logo

    ##
    # :attr_reader: photo
    #
    # Returns +String+
    #
    property :photo

    class << self
      ##
      # Find by ID
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil
      #
      # [+id+]
      #     +Integer+
      #
      def find(id)
        client = MetalArchives::Clients::Band.new :id => id
        client.find_by_id
      rescue MetalArchives::Errors::APIError
        nil
      end

      ##
      # Find by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO366::Country+
      #     - +:year_formation+: rdoc-ref:Range of +Date+
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
      #
      def find_by(query)
        client = MetalArchives::Clients::Band.new query
        client.find
      rescue MetalArchives::Errors::APIError
        nil
      end

      ##
      # Search by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Band
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO366::Country+
      #     - +:year_formation+: rdoc-ref:Range of +Date+
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
      #
      def search_by(query)
        client = MetalArchives::Clients::Band.new query
        client.search
      end

      ##
      # Search by name, resolves to rdoc-ref:Band.search_by <tt>(:name => name)</tt>
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Band
      #
      # [+name+]
      #     +String+
      #
      def search(name)
        search_by :name => name
      end
    end
  end
end
