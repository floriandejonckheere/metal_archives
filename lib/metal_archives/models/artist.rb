require 'date'

module MetalArchives
  class Artist < BaseModel
    property :id
    property :name
    property :aliases,                        :multiple => true
    property :country,      :type => MetalArchives::Country
    property :location
    property :date_formed,  :type => Date
    property :date_active,  :type => Range,   :multiple => true
    property :genres,                         :multiple => true
    property :themes,                         :multiple => true
    property :label,        :type => MetalArchives::Label
    property :comment

    enum :status,       :values => [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]


    # TODO: n-way associations

    class << self
      def search(name)
        results = []
        results
      end

      def find_by_name(name, id)
        Client.find_resource(
            :artist,
              :name => name,
              :id => id
        )
      end
    end
  end
end
