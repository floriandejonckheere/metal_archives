# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Release parser
    #
    class Release < Parser # :nodoc:
      class << self
        TYPE_TO_QUERY = {
          full_length: 1,
          live: 2,
          demo: 3,
          single: 4,
          ep: 5,
          video: 6,
          boxed_set: 7,
          split: 8,
          compilation: 10,
          split_video: 12,
          collaboration: 13,
        }.freeze

        TYPE_TO_SYM = {
          "Full-length" => :full_length,
          "Live album" => :live,
          "Demo" => :demo,
          "Single" => :single,
          "EP" => :ep,
          "Video" => :video,
          "Boxed set" => :boxed_set,
          "Split" => :split,
          "Compilation" => :compilation,
          "Split video" => :split_video,
          "Collaboration" => :collaboration,
        }.freeze

        FORMAT_TO_QUERY = {
          cd: "CD",
          cassette: "Cassette",
          vinyl: "Vinyl*",
          vhs: "VHS",
          dvd: "DVD",
          "2dvd": "2DVD",
          digital: "Digital",
          blu_ray: "Blu-ray*",
          other: "Other",
          unknown: "Unknown",
        }.freeze

        FORMAT_TO_SYM = {
          "CD" => :cd,
          "Cassette" => :cassette,
          "VHS" => :vhs,
          "DVD" => :dvd,
          "2DVD" => :"2dvd",
          "Digital" => :digital,
          "Other" => :other,
          "Unknown" => :unknown,
        }.freeze

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
            bandName: query[:band_name] || "",
            releaseTitle: query[:title] || "",
            releaseYearFrom: query[:from_year] || "",
            releaseMonthFrom: query[:from_month] || "",
            releaseYearTo: query[:to_year] || "",
            releaseMonthTo: query[:to_month] || "",
            country: map_countries(query[:country]) || "",
            location: query[:location] || "",
            releaseLabelName: query[:label_name] || "",
            releaseCatalogNumber: query[:catalog_id] || "",
            releaseIdentifiers: query[:identifier] || "",
            releaseRecordingInfo: query[:recording_info] || "",
            releaseDescription: query[:version_description] || "",
            releaseNotes: query[:notes] || "",
            genre: query[:genre] || "",
            releaseType: map_types(query[:types]),
            releaseFormat: map_formats(query[:formats]),
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
            title: nil,
            band: nil,
            type: nil,
            date_released: nil,
            catalog_id: nil,
            identifier: nil,
            version_description: nil,
            format: nil,
            limitation: nil,
          }

          doc = Nokogiri::HTML response

          props[:title] = sanitize doc.css("#album_info .album_name a").first.content

          # Band
          band_doc = doc.css("#album_info .band_name a").first
          id = Integer(band_doc.attr("href").split("/").last)

          props[:band] = MetalArchives::Band.find(id)

          doc.css("#album_info dl").each do |dl|
            dl.search("dt").each do |dt|
              content = sanitize dt.next_element.content

              next if content == "N/A"

              case sanitize(dt.content)
              when "Type:"
                props[:type] = map_type content
              when "Release date:"
                props[:date_released] = Parsers::Date.parse(content)
              when "Catalog ID:"
                props[:catalog_id] = content
              when "Identifier:"
                props[:identifier] = content
              when "Version desc.:"
                props[:version_description] = content
              when "Label:"
                # TODO: label
              when "Format:"
                props[:format] = map_format content
              when "Limitation:"
                props[:limitation] = content.to_i
              when "Reviews:"
                next if content == "None yet"
                # TODO: reviews
              else
                raise Errors::ParserError, "Unknown token: #{dt.content}"
              end
            end
          end

          props
        rescue StandardError => e
          e.backtrace.each { |b| MetalArchives.config.logger.error b }
          raise Errors::ParserError, e
        end

        private

        ##
        # Map MA countries to query parameters
        #
        # Returns +Array+ of +ISO3166::Country+
        #
        # [+types+]
        #     +Array+ containing one or more +String+s
        #
        def map_countries(countries)
          countries&.map(&:alpha2)
        end

        ##
        # Map MA release type to query parameters
        #
        # Returns +Array+ of +Integer+
        #
        # [+types+]
        #     +Array+ containing one or more +Symbol+, see rdoc-ref:Release.type
        #
        def map_types(type_syms)
          return unless type_syms

          types = []
          type_syms.each do |type|
            raise Errors::ParserError, "Unknown type: #{type}" unless TYPE_TO_QUERY[type]

            types << TYPE_TO_QUERY[type]
          end

          types
        end

        ##
        # Map MA release type to +Symbol+
        #
        # Returns +Symbol+, see rdoc-ref:Release.type
        #
        def map_type(type)
          raise Errors::ParserError, "Unknown type: #{type}" unless TYPE_TO_SYM[type]

          TYPE_TO_SYM[type]
        end

        ##
        # Map MA release format to query parameters
        #
        # Returns +Array+ of +Integer+
        #
        # [+types+]
        #     +Array+ containing one or more +Symbol+, see rdoc-ref:Release.type
        #
        def map_formats(format_syms)
          return unless format_syms

          formats = []
          format_syms.each do |format|
            raise Errors::ParserError, "Unknown format: #{format}" unless FORMAT_TO_QUERY[format]

            formats << FORMAT_TO_QUERY[format]
          end

          formats
        end

        ##
        # Map MA release format to +Symbol+
        #
        # Returns +Symbol+, see rdoc-ref:Release.format
        #
        def map_format(format)
          return :cd if /CD/.match?(format)
          return :vinyl if /[Vv]inyl/.match?(format)
          return :blu_ray if /[Bb]lu.?[Rr]ay/.match?(format)

          raise Errors::ParserError, "Unknown format: #{format}" unless FORMAT_TO_SYM[format]

          FORMAT_TO_SYM[format]
        end
      end
    end
  end
end
