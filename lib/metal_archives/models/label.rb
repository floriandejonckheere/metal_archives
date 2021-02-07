# frozen_string_literal: true

require "date"
require "countries"

module MetalArchives
  ##
  # Represents a record label
  #
  class Label < BaseModel
    ##
    # :attr_reader: id
    #
    # Returns +Integer+
    #
    property :id, type: Integer

    ##
    # :attr_reader: name
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :name

    ##
    # :attr_reader: address
    #
    # Returns multiline +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :address

    ##
    # :attr_reader: country
    #
    # Returns +ISO316::Country+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :country, type: ISO3166::Country

    ##
    # :attr_reader: phone
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :phone

    ##
    # :attr_reader: specializations
    #
    # Returns +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :specializations, multiple: true

    ##
    # :attr_reader: date_founded
    #
    # Returns +NilDate+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :date_founded, type: NilDate

    ##
    # :attr_reader: sub_labels
    #
    # Returns +Array+ of rdoc-ref:Label
    #
    property :sub_labels, type: MetalArchives::Label, multiple: true

    ##
    # :attr_reader: online_shopping
    #
    # Returns +Boolean+
    #
    boolean :online_shopping

    ##
    # :attr_reader: contact
    #
    # Returns +Hash+ with the following keys: +title+, +content+
    #
    property :contact, type: Hash, multiple: true

    ##
    # :attr_reader: status
    #
    # Returns +:active+, +:closed+ or +:unknown+
    #
    enum :status, values: [:active, :closed, :unknown]

    class << self
      ##
      # Search by name.
      #
      # Returns +Array+ of rdoc-ref:Label
      #
      def search(_name)
        []
      end

      ##
      # Find by name and id.
      #
      # Returns rdoc-ref:Label
      #
      def find_by_name(name, id)
        client.find_resource(
          :band,
          name: name,
          id: id,
        )
      end
    end
  end
end
