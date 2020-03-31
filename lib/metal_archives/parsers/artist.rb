# frozen_string_literal: true

require "json"
require "date"
require "countries"

require "metal_archives/middleware/rewrite_endpoint"

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
          params = {
            query: query[:name] || "",
          }

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
          props = {}
          doc = Nokogiri::HTML response

          # Photo
          unless doc.css(".member_img").empty?
            photo_uri = URI doc.css(".member_img img").first.attr("src")
            props[:photo] = Middleware::RewriteEndpoint.rewrite photo_uri
          end

          doc.css("#member_info dl").each do |dl|
            dl.css("dt").each do |dt|
              content = sanitize(dt.next_element.content)

              next if content == "N/A"

              case sanitize(dt.content)
              when "Real/full name:"
                props[:name] = content
              when "Age:"
                date = content.strip.gsub(/[0-9]* *\(born ([^\)]*)\)/, '\1')
                begin
                  props[:date_of_birth] = NilDate.parse date
                rescue MetalArchives::Errors::ArgumentError => e
                  dob = Date.parse date
                  props[:date_of_birth] = NilDate.new dob.year, dob.month, dob.day
                end
              when "R.I.P.:"
                begin
                  dod = Date.parse content
                  props[:date_of_death] = NilDate.new dod.year, dod.month, dod.day
                rescue ArgumentError => e
                  props[:date_of_death] = NilDate.parse content
                end
              when "Died of:"
                props[:cause_of_death] = content
              when "Place of origin:"
                props[:country] = ISO3166::Country.find_country_by_name(sanitize(dt.next_element.css("a").first.content))
                location = dt.next_element.xpath("text()").map(&:content).join("").strip.gsub(/[()]/, "")
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
          props[:aliases] = []
          alt = sanitize doc.css(".band_member_name").first.content
          props[:aliases] << alt unless props[:name] == alt

          # Active bands
          props[:bands] = []

          proc = proc do |row|
            link = row.css("h3 a")
            band = if link.any?
                     # Band name contains a link
                     MetalArchives::Band.find Integer(link.attr("href").text.gsub(%r(^.*/([^/#]*)#.*$), '\1'))
                   else
                     # Band name does not contain a link
                     sanitize row.css("h3").text
                   end

            r = row.css(".member_in_band_role")

            range = parse_year_range r.xpath("text()").map(&:content).join("").strip.gsub(/[\n\r\t]/, "").gsub(/.*\((.*)\)/, '\1')
            role = sanitize r.css("strong").first.content

            {
              band: band,
              date_active: range,
              role: role,
            }
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
            if row["id"].match /^header_/
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
