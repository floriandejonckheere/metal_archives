# frozen_string_literal: true

require 'date'
require 'countries'

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
    property :id

    ##
    # :attr_reader: name
    #
    # Returns +String+
    #
    property :name

    ##
    # :attr_reader: address
    #
    # Returns multiline +String+
    #
    property :address

    ##
    # :attr_reader: country
    #
    # Returns +ISO316::Country+
    #
    property :country, :type => ISO3166::Country

    ##
    # :attr_reader: phone
    #
    # Returns +String+
    #
    property :phone

    ##
    # :attr_reader: specializations
    #
    # Returns +Array+ of +String+
    #
    property :specializations, :multiple => true

    ##
    # :attr_reader: date_founded
    #
    # Returns +Date+
    #
    property :date_founded, :type => Date

    ##
    # :attr_reader: sub_labels
    #
    # Returns +Array+ of rdoc-ref:Label
    #
    property :sub_labels, :type => MetalArchives::Label, :multiple => true

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
    property :contact, :type => Hash, :multiple => true

    ##
    # :attr_reader: status
    #
    # Returns +:active+, +:closed+ or +:unknown+
    #
    enum :status, :values => %i[active closed unknown]

    class << self
      ##
      # Search by name.
      #
      # Returns +Array+ of rdoc-ref:Label
      #
      def search(_name)
        results = []
        results
      end

      ##
      # Find by name and id.
      #
      # Returns rdoc-ref:Label
      #
      def find_by_name(name, id)
        client.find_resource(
          :band,
          :name => name,
          :id => id
        )
      end
    end
  end
end
