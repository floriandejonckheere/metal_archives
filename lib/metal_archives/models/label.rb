# frozen_string_literal: true

module MetalArchives
  ##
  # Represents a record label
  #
  class Label < Base
    ##
    # :attr_reader: id
    #
    # [Returns]
    # - +Integer+
    #
    attribute :id, type: :integer

    ##
    # :attr_reader: name
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :name

    ##
    # :attr_reader: address
    #
    # [Returns]
    # - raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :address

    ##
    # :attr_reader: country
    #
    # [Returns]
    # - +ISO316::Country+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :country, type: :country

    ##
    # :attr_reader: phone
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :phone

    ##
    # :attr_reader: specializations
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :specializations, multiple: true

    ##
    # :attr_reader: date_founded
    #
    # [Returns]
    # - +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :date_founded, type: :date

    ##
    # :attr_reader: sub_labels
    #
    # [Returns]
    # - +Array+ of rdoc-ref:Label
    #
    attribute :sub_labels, type: :label, multiple: true

    ##
    # :attr_reader: online_shopping
    #
    # [Returns]
    # - +Boolean+
    #
    attribute :online_shopping, type: :boolean

    ##
    # :attr_reader: contact
    #
    # [Returns]
    # - +Hash+ with the following keys: +title+, +content+
    #
    attribute :contact, type: :hash, multiple: true

    ##
    # :attr_reader: status
    #
    # [Returns]
    # - +Symbol+, one of +:active+, +:closed+ or +:unknown+
    #
    attribute :status, type: :symbol, enum: [:active, :closed, :unknown]

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
