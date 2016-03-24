module MetalArchives
  class Artist < BaseModel
    property :name,         :type => String
    property :country,      :type => MetalArchives::Country
    property :location,     :type => String
    property :date_formed,  :type => Date
    property :date_active,  :type => Range,   :multiple => true
    property :genres,       :type => String,  :multiple => true
    property :themes,       :type => String,  :multiple => true
    property :label,        :type => MetalArchives::Label
    property :comment,      :type => String

    enum :status,       :values => [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]


    # TODO: n-way associations

    class << self
      def find_by_name(name)

      end
    end
  end
end
