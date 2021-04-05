# frozen_string_literal: true

module MetalArchives
  module Builders
    ##
    # Artist builder
    #
    class Artist < Base
      attr_reader :artist

      def initialize(artist)
        super()

        @artist = artist
      end

      def build!
        # Attributes
        artist.set(**attributes(
          http.get("/artist/view/id/#{artist.id}"),
        ))

        # Biography
        artist.biography = http
          .get("/artist/read-more/id/#{artist.id}/field/biography")

        # Trivia
        artist.trivia = http
          .get("/artist/read-more/id/#{artist.id}/field/trivia")

        artist.links = related_links(
          http.get("/link/ajax-list/type/person/id/#{artist.id}"),
        )
      end

      private

      def attributes(response)
        doc = Nokogiri::HTML(response.body.to_s)

        info = doc.at("#member_info")

        name = info.at("dl dt:contains('Real/full name') ~ dd")&.content&.strip

        country, location = info.at("dl dt:contains('Place of origin') ~ dd")&.content&.match(/(?<country>[^(]*)(\((?<location>[^)]*)\))?/)&.captures

        # TODO: remove "N/A"
        {
          name: name,
          date_of_birth: date(info.at("dl dt:contains('Age') ~ dd")&.content&.gsub(/[0-9]* *\(born ([^)]*)\)/, '\1')),
          date_of_death: date(info.at("dl dt:contains('R.I.P.') ~ dd")&.content),
          cause_of_death: info.at("dl dt:contains('Died of') ~ dd")&.content,
          gender: info.at("dl dt:contains('Gender') ~ dd")&.content&.downcase&.to_sym,
          country: ISO3166::Country.find_country_by_name(country&.strip),
          location: location&.strip,
          aliases: [info.at(".band_member_name")&.content] - [name],
          photo: uri(doc.at(".member_img img")&.attr("src")),
          bands: bands(doc),
        }
      end

      def bands(document)
        document
          .css("#artist_tab_active .member_in_band")
          .map { |row| band(row).merge(active: true).compact } +
          document
            .css("#artist_tab_past .member_in_band")
            .map { |row| band(row).merge(active: false).compact }
      end

      def band(row)
        role = row.css(".member_in_band_role")

        {
          id: row.at("h3 a")&.attr("href")&.gsub(%r(^.*/([0-9]*).*$), '\1')&.to_i,
          name: row.at("h3").text,
          role: role.at("strong")&.content,
          years_active: year(role.text.strip.tr("\n", " ").gsub(/.*\(([^)]*)\)$/, '\1')),
        }
      end

      def related_links(response)
        type = :official

        Nokogiri::HTML(response.body.to_s).css("#linksTablemain tr").filter_map do |row|
          next if row["id"] == "noLinks"

          # Set type on "header_unofficial" row
          if row["id"].start_with?("header_")
            type = row["id"].delete_prefix("header_").downcase.to_sym

            next
          end

          {
            url: row.at("td a").attr("href"),
            type: type,
            title: row.at("td a").content,
          }
        end
      end
    end
  end
end
