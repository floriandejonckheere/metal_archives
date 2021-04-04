# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Artist parser
    #
    class Artist < Parser # :nodoc:
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
          {
            query: query[:name] || "",
          }
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

            date_of_birth: nil,
            date_of_death: nil,
            cause_of_death: nil,
            gender: nil,

            country: nil,
            location: nil,

            photo: nil,

            bands: [],
          }

          doc = Nokogiri::HTML response

          # Photo
          unless doc.css(".member_img").empty?
            photo_uri = URI doc.css(".member_img img").first.attr("src")
            props[:photo] = rewrite(photo_uri)
          end

          doc.css("#member_info dl").each do |dl|
            dl.css("dt").each do |dt|
              content = sanitize(dt.next_element.content)

              next if content == "N/A"

              case sanitize(dt.content)
              when "Real/full name:"
                props[:name] = content
              when "Age:"
                props[:date_of_birth] = Parsers::Date.parse(content.strip.gsub(/[0-9]* *\(born ([^)]*)\)/, '\1'))
              when "R.I.P.:"
                props[:date_of_death] = Parsers::Date.parse(content)
              when "Died of:"
                props[:cause_of_death] = content
              when "Place of origin:"
                props[:country] = Country.parse(sanitize(dt.next_element.css("a").first.content))
                location = dt.next_element.xpath("text()").map(&:content).join.strip.gsub(/[()]/, "")
                props[:location] = location unless location.empty?
              when "Gender:"
                case content
                when "Male"
                  props[:gender] = :male
                when "Female"
                  props[:gender] = :female
                else
                  raise Errors::ParserError, "Unknown gender: #{content}"
                end
              else
                raise Errors::ParserError, "Unknown token: #{dt.content}"
              end
            end
          end

          # Aliases
          alt = sanitize doc.css(".band_member_name").first.content
          props[:aliases] << alt unless props[:name] == alt

          # Active bands
          proc = proc do |row|
            link = row.css("h3 a")

            name, id = nil

            if link.any?
              # Band name contains a link
              id = Integer(link.attr("href").text.gsub(%r(^.*/([^/#]*)#.*$), '\1'))
            else
              # Band name does not contain a link
              name = sanitize row.css("h3").text
            end

            r = row.css(".member_in_band_role")

            range = Parsers::Year.parse(r.xpath("text()").map(&:content).join.strip.gsub(/[\n\r\t]/, "").gsub(/.*\((.*)\)/, '\1'))
            role = sanitize r.css("strong")&.first&.content

            {
              id: id,
              name: name,
              years_active: range,
              role: role,
            }.compact
          end

          doc.css("#artist_tab_active .member_in_band").each do |row|
            props[:bands] << proc.call(row).merge(active: true)
          end

          doc.css("#artist_tab_past .member_in_band").each do |row|
            props[:bands] << proc.call(row).merge(active: false)
          end

          props
        rescue StandardError => e
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end

        ##
        # Parse links HTML page
        #
        # Returns +Hash+
        #
        # [Raises]
        # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
        #
        def parse_links_html(response)
          links = []

          doc = Nokogiri::HTML response

          # Default to official links
          type = :official

          doc.css("#linksTablemain tr").each do |row|
            if /^header_/.match?(row["id"])
              type = row["id"].gsub(/^header_/, "").downcase.to_sym
            else
              a = row.css("td a").first

              # No links have been added yet
              next unless a

              links << {
                url: a["href"],
                type: type,
                title: a.content,
              }
            end
          end

          links
        rescue StandardError => e
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end
      end
    end
  end
end
