# frozen_string_literal: true

module MetalArchives
  module Builders
    ##
    # Band builder
    #
    class Band < Base
      attr_reader :band

      def initialize(band)
        super()

        @band = band
      end

      def build!
        # Attributes
        band.set(**attributes(
          http.get("/band/view/id/#{band.id}"),
        ))

        # Comment
        band.comment = http
          .get("/band/read-more/id/#{band.id}")

        # TODO: label

        # Similar artists
        band.similar = similar_bands(
          http.get("/band/ajax-recommendations/id/#{band.id}?showMoreSimilar=1"),
        )

        band.links = related_links(
          http.get("/link/ajax-list/type/band/id/#{band.id}"),
        )

        band.releases = releases(
          http.get("/band/discography/id/#{band.id}/tab/all"),
        )
      end

      private

      def attributes(response)
        doc = Nokogiri::HTML(response.body.to_s)

        info = doc.at("#band_info")

        years_active, aliases = years(doc.at("dl dt:contains('Years active') ~ dd")&.content)

        {
          name: info.at(".band_name a").content,
          aliases: aliases,
          country: ISO3166::Country.find_country_by_name(doc.at("dl dt:contains('Country') ~ dd")&.content&.strip),
          location: doc.at("dl dt:contains('Location') ~ dd")&.content,
          status: symbol(doc.at("dl dt:contains('Status') ~ dd")&.content),
          date_formed: date(doc.at("dl dt:contains('Formed in') ~ dd")&.content),
          genres: genres(doc.at("dl dt:contains('Genre') ~ dd")&.content),
          lyrical_themes: lyrical_themes(doc.at("dl dt:contains('Lyrical themes') ~ dd")&.content),
          independent: doc.at("dl dt:contains('label') ~ dd")&.content&.include?("independent") || false,
          years_active: years_active,
          logo: uri(doc.at(".band_name_img img")&.attr("src")),
          photo: uri(doc.at(".band_img img")&.attr("src")),
          members: members(doc),
        }
      end

      def members(document)
        document
          .css("#band_tab_members_current .lineupRow")
          .map { |row| member(row).merge(current: true).compact } +
          document
            .css("#band_tab_members_past .lineupRow")
            .map { |row| member(row).merge(current: false).compact }
      end

      def member(row)
        link = row.at("a")

        if link
          id = link["href"].split("/").last.to_i
          name = link.content
        else
          name = row.at("h3").content
        end

        r = row.css("td").last.text
        role, range = r.match(/(.*)\(([^(]*)\)/)&.captures

        years, _aliases = years(range)

        {
          name: name,
          id: id,
          years_active: years.first,
          role: string(role),
        }
      end

      def similar_bands(response)
        doc = Nokogiri::HTML(response.body.to_s)
        doc.css("#artist_list tbody tr").filter_map do |row|
          next if row.at("td")["id"] == "show_more"

          {
            band: MetalArchives::Band.find(row.at("td:nth-child(1) a")["href"].split("/").last.to_i),
            score: row.at("td:nth-child(4) span").content.strip.to_i,
          }
        end
      end

      def related_links(response)
        doc = Nokogiri::HTML(response.body.to_s)

        doc.css("#band_links ul li a").flat_map do |link_a|
          type = symbol(link_a.content)

          doc.css("#{link_a['href']} table tr a").map do |band_a|
            {
              url: band_a["href"],
              type: type,
              title: string(band_a.content),
            }
          end
        end
      end

      def releases(response)
        doc = Nokogiri::HTML(response.body.to_s)

        doc.css("tbody tr").map do |row|
          MetalArchives::Release.find(row.at("td:nth-child(1) a")["href"].split("/").last.to_i)
        end
      end
    end
  end
end
