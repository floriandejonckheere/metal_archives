require 'date'
require 'countries'

module MetalArchives

  ##
  # Represents an artist (person or group)
  #
  class Artist < BaseModel
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

    # TODO: n-way associations

    class << self
      ##
      # Search by name.
      #
      # Returns +Array+ of rdoc-ref:Artist
      #
      def search(name)
        results = []
        results
      end

      ##
      # Find by name and id.
      #
      # Returns rdoc-ref:Artist
      #
      def find_by_name(name, id)
        client.find_resource(
            :artist,
              :name => name,
              :id => id
        )
      end
    end
  end
end
