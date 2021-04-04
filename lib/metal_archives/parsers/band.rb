# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Band parser
    #
    class Band < Parser # :nodoc:
      class << self
        ##
        # Map attributes to MA attributes
        #
        # Returns +Hash+
        #
        # [+params+]
        #     +Hash+
        #
        def map_params(query)
          params = {
            bandName: query[:name] || "",
            exactBandMatch: (query[:exact] ? 1 : 0),
            genre: query[:genre] || "",
            yearCreationFrom: query[:year]&.begin || "",
            yearCreationTo: query[:year]&.end || "",
            bandNotes: query[:comment] || "",
            status: map_status(query[:status]),
            themes: query[:lyrical_themes] || "",
            location: query[:location] || "",
            bandLabelName: query[:label] || "",
            indieLabelBand: (query[:independent] ? 1 : 0),
          }

          params[:country] = []
          Array(query[:country]).each do |country|
            params[:country] << (country.is_a?(ISO3166::Country) ? country.alpha2 : (country || ""))
          end
          params[:country] = params[:country].first if params[:country].size == 1

          params
        end

        ##
        # Parse main HTML page
        #
        # Returns +Hash+
        #
        # [Raises]
        # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
        #
        def parse_html(response)
          # Set default props
          props = {
            name: nil,
            aliases: [],

            logo: nil,
            photo: nil,

            country: nil,
            location: nil,

            status: nil,
            date_formed: nil,
            years_active: [],
            independent: nil,

            genres: [],
            lyrical_themes: [],

            members: [],
          }

          doc = Nokogiri::HTML response

          props[:name] = sanitize doc.css("#band_info .band_name a").first.content

          # Logo
          unless doc.css(".band_name_img").empty?
            logo_uri = URI doc.css(".band_name_img img").first.attr("src")
            props[:logo] = rewrite(logo_uri)
          end

          # Photo
          unless doc.css(".band_img").empty?
            photo_uri = URI doc.css(".band_img img").first.attr("src")
            props[:photo] = rewrite(photo_uri)
          end

          doc.css("#band_stats dl").each do |dl|
            dl.search("dt").each do |dt|
              content = sanitize(dt.next_element.content)

              next if content == "N/A"

              case dt.content
              when "Country of origin:"
                props[:country] = Country.parse(sanitize(dt.next_element.css("a").first.content))
              when "Location:"
                props[:location] = content
              when "Status:"
                props[:status] = content.downcase.tr(" -", "_").to_sym
              when "Formed in:"
                props[:date_formed] = Parsers::Date.parse(content)
              when "Genre:"
                props[:genres] = Parsers::Genre.parse(content)
              when "Lyrical themes:"
                content.split(",").each do |theme|
                  t = theme.split.map(&:capitalize)
                  t.delete "(early)"
                  t.delete "(later)"
                  props[:lyrical_themes] << t.join(" ")
                end
              when /(Current|Last) label:/
                props[:independent] = (content == "Unsigned/independent")
                # TODO: label
              when "Years active:"
                content.split(",").each do |range|
                  # Aliases
                  range.scan(/\(as ([^)]*)\)/).each { |name| props[:aliases] << name.first }
                  # Ranges
                  props[:years_active] << Parsers::Year.parse(range.gsub(/ *\(as ([^)]*)\) */, ""))
                end
              else
                raise Errors::ParserError, "Unknown token: #{dt.content}"
              end
            end
          end

          # Members
          proc = proc do |row|
            link = row.css("a")

            if link.any?
              # Artist name contains a link
              id = Integer(link.attr("href").text.split("/").last)
              name = sanitize link.text
            else
              # Artist name does not contain a link
              name = sanitize row.css("h3").text
            end

            r = row.css("td").last.text
            role, range = r.match(/(.*)\(([^(]*)\)/)&.captures

            range = Parsers::Year.parse(range)

            {
              id: id,
              name: name,
              years_active: range,
              role: sanitize(role),
            }.compact
          end

          doc.css("#band_tab_members_current .lineupRow").each do |row|
            props[:members] << proc.call(row).merge(current: true)
          end

          doc.css("#band_tab_members_past .lineupRow").each do |row|
            props[:members] << proc.call(row).merge(current: false)
          end

          props
        rescue StandardError => e
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end

        ##
        # Parse similar bands HTML page
        #
        # Returns +Hash+
        #
        # [Raises]
        # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
        #
        def parse_similar_bands_html(response)
          similar = []

          doc = Nokogiri::HTML response
          doc.css("#artist_list tbody tr").each do |row|
            similar << {
              id: row.css("td a").first["href"].split("/").last.to_i,
              score: row.css("td").last.content.strip,
            }
          end

          similar
        rescue StandardError => e
          MetalArchives.config.logger e.message
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end

        ##
        # Parse related links HTML page
        #
        # Returns +Hash+
        #
        # [Raises]
        # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
        #
        def parse_related_links_html(response)
          links = []

          doc = Nokogiri::HTML response
          doc.css("#linksTableOfficial td a").each do |a|
            links << {
              url: a["href"],
              type: :official,
              title: a.content,
            }
          end
          doc.css("#linksTableOfficial_merchandise td a").each do |a|
            links << {
              url: a["href"],
              type: :merchandise,
              title: a.content,
            }
          end

          links
        rescue StandardError => e
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end

        ##
        # Parse releases HTML page
        #
        # Returns +Array+
        # [Raises]
        # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
        #
        def parse_releases_html(response)
          releases = []

          doc = Nokogiri::HTML response
          doc.css("tbody tr td:first a").each do |a|
            id = a["href"].split("/").last.to_i
            releases << MetalArchives::Release.find(id)
          end

          releases
        rescue StandardError => e
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end

        private

        ##
        # Map MA band status
        #
        # Returns +Symbol+
        #
        # [Raises]
        # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
        #
        def map_status(status)
          s = {
            nil => "",
            :active => "Active",
            :split_up => "Split-up",
            :on_hold => "On hold",
            :unknown => "Unknown",
            :changed_name => "Changed name",
            :disputed => "Disputed",
          }

          raise Errors::ParserError, "Unknown status: #{status}" unless s[status]

          s[status]
        end
      end
    end
  end
end
