require 'date'

module MetalArchives

  ##
  # Represents an artist (person or group)
  #
  class Artist < BaseModel
    property :id
    property :name
    property :aliases,                        :multiple => true
    property :country,      :type => MetalArchives::Country
    property :location
    property :date_formed,  :type => Date
    property :date_active,  :type => MetalArchives::Range,   :multiple => true
    property :genres,                         :multiple => true
    property :themes,                         :multiple => true
    property :label,        :type => MetalArchives::Label
    property :comment

    enum :status,       :values => [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]

    # TODO: n-way associations

    class << self
      ##
      # Search for an artist.
      #
      # Returns an +Array+ with rdoc-ref:Artist instances.
      #
      def search(name)
        results = []
        results
      end

      ##
      # Find an artist by name and id.
      #
      # Returns an rdoc-ref:Artist instance.
      #
      # Raises rdoc-ref:
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
