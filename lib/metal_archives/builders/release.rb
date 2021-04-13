# frozen_string_literal: true

module MetalArchives
  module Builders
    ##
    # Release builder
    #
    class Release < Base
      attr_reader :release

      def initialize(release)
        super()

        @release = release
      end

      def build!
        # Attributes
        release.set(**attributes(
          http.get("/albums/artist/id/#{release.id}"),
        ))

        # TODO: label
        # TODO: songs
        # TODO: other versions
        # TODO: reviews
        # TODO: additional notes
      end

      private

      def attributes(response)
        doc = Nokogiri::HTML(response.body.to_s)

        info = doc.at("#album_info")

        band_id = info.at(".band_name a")&.attr("href")&.split("/")&.last&.to_i

        # TODO: remove "N/A"
        {
          title: info.at(".album_name").content,
          type: symbol(info.at("dl dt:contains('Type') ~ dd")&.content),
          date_released: date(info.at("dl dt:contains('Release date') ~ dd")&.content),
          catalog_id: info.at("dl dt:contains('Catalog ID') ~ dd")&.content,
          version_description: info.at("dl dt:contains('Version desc') ~ dd")&.content,
          format: symbol(format(info.at("dl dt:contains('Format') ~ dd")&.content)),
          limitation: info.at("dl dt:contains('Limitation') ~ dd")&.contents&.to_i,
          band: MetalArchives::Band.new(id: band_id),
        }
      end

      def format(string)
        return :vinyl if string.include? "vinyl"

        string
      end
    end
  end
end
