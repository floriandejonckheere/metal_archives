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

    # TODO: releases
    # TODO: members
    # TODO: reviews
    # TODO: similar artists
    # TODO: links
    # TODO: artist art

    class << self
      ##
      # Search by attributes
      #
      # Returns rdoc-ref:Artist
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+
      #
      def search_by(query)
        client.search_resource(
          :artist,
            query
        )
      end

      ##
      # Search by name.
      #
      # Returns +Array+ of rdoc-ref:Artist
      #
      def search(name)
        search_by :name => name
      end

      ##
      # Search by genre.
      #
      # Returns +Array+ of rdoc-ref:Artist
      #
      def search_by_genre(name)
        raise NotImplementedError
      end

      ##
      # Find by attributes
      #
      # Returns rdoc-ref:Artist
      #
      # Returns first match by attributes
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+
      #
      def find_by(query)
        client.find_resource(
          :artist,
            query
        )
      end

      ##
      # Find by name.
      #
      # Returns rdoc-ref:Artist
      #
      # Returns first match by name or exact match
      # if id is specified
      #
      def find(name, id = nil)
        if id
          find_by :name => name,
                  :id => id
        else
          find_by :name => name
        end
      end
    end
  end
end
