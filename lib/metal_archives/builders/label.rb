# frozen_string_literal: true

module MetalArchives
  module Builders
    ##
    # Label builder
    #
    class Label < Base
      attr_reader :label

      def initialize(label)
        super()

        @label = label
      end

      def build!
        # Attributes
        label.set(**attributes(
          http.get("/labels/id/#{label.id}"),
        ))

        # TODO: parent label, sub-labels
        # TODO: roster
        # TODO: releases
        # TODO: links
        # TODO: notes
      end

      private

      def attributes(response)
        doc = Nokogiri::HTML(response.body.to_s)

        info = doc.at("#label_info")

        # TODO: remove "N/A"
        {
          name: info.at(".label_name").content,
          contact: doc.css("#label_contact a").map { |c| { title: c.content, content: c["href"] } },
          address: info.at("dl dt:contains('Address') ~ dd")&.content,
          country: ISO3166::Country.find_country_by_name(info.at("dl dt:contains('Country') ~ dd")&.content),
          phone: info.at("dl dt:contains('Phone') ~ dd")&.content,
          status: symbol(info.at("dl dt:contains('Status') ~ dd")&.content),
          specializations: genres(info.at("dl dt:contains('Styles') ~ dd")&.content),
          date_founded: date(info.at("dl dt:contains('Founding date') ~ dd")&.content),
          online_shopping: info.at("dl dt:contains('Online shopping') ~ dd")&.content&.include?("Yes"),
        }
      end
    end
  end
end
