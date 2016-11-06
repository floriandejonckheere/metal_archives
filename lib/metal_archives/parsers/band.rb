require 'json'
require 'date'
require 'countries'

module MetalArchives
module Parsers
  ##
  # Band parser
  #
  class Band # :nodoc:
    class << self
      def find_endpoint(id)
        "http://www.metal-archives.com/band/view/id/#{id}"
      end

      def search_endpoint(query)
        "http://www.metal-archives.com/search/ajax-advanced/searching/bands/"
      end

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
          :bandName => query[:name] || '',
          :exactBandMatch => (!!query[:exact] ? 1 : 0),
          :genre => query[:genre] || '',
          :yearCreationFrom => (query[:year] and query[:year].begin ? query[:year].begin.year : '') || '',
          :yearCreationTo => (query[:year] and query[:year].end ? query[:year].end.year : '') || '',
          :bandNotes => query[:comment] || '',
          :status => map_status(query[:status]),
          :themes => query[:lyrical_themes] || '',
          :location => query[:location] || '',
          :bandLabelName => query[:label] || '',
          :indieLabelBand => (!!query[:independent] ? 1 : 0)
        }

        params[:country] = []
        Array(query[:country]).each do |country|
          params[:country] << (country.is_a?(ISO3166::Country) ? country.alpha2 : (country || ''))
        end
        params[:country] = params[:country].first if (params[:country].size == 1)

        params
      end

      def parse_html(response)
        props = {}
        doc = Nokogiri::HTML(response)

        props[:name] = doc.css('#band_info .band_name a').first.content
        props[:comment] = doc.css('#band_info .band_comment').first.content.gsub(/\n/, '').strip

        props[:aliases] = []

        doc.css('#band_stats dl').each do |dl|
          dl.search('dt').each do |dt|
            case dt.content
            when 'Country of origin:'
              props[:country] = ISO3166::Country.find_country_by_name dt.next_element.css('a').first.content
            when 'Location:'
              break if dt.next_element.content == 'N/A'
              props[:location] = dt.next_element.content
            when 'Status:'
              props[:status] = dt.next_element.content.downcase.gsub(/ /, '_').to_sym
            when 'Formed in:'
              break if dt.next_element.content == 'N/A'
              props[:date_formed] = Date.new dt.next_element.content.to_i
            when 'Genre:'
              break if dt.next_element.content == 'N/A'
              props[:genres] = ParserHelper.parse_genre dt.next_element.content
            when 'Lyrical themes:'
              props[:lyrical_themes] = []
              break if dt.next_element.content == 'N/A'
              dt.next_element.content.split(',').each do |theme|
                t = theme.split.map(&:capitalize)
                t.delete '(early)'
                t.delete '(later)'
                props[:lyrical_themes] << t.join(' ')
              end
            when /(Current|Last) label:/
              props[:independent] = (dt.next_element.content == 'Unsigned/independent')
              # TODO
            when 'Years active:'
              break if dt.next_element.content == 'N/A'
              props[:date_active] = []
              dt.next_element.content.split(',').each do |range|
                # Aliases
                range.scan(/\(as ([^)]*)\)/).each { |name| props[:aliases] << name.first }
                # Ranges
                range.gsub!(/ *\(as ([^)]*)\) */, '')
                r = range.split('-')
                date_start = (r.first == '?' ? nil : Date.new(r.first.to_i))
                date_end = (r.last == '?' or r.last == 'present' ? nil : Date.new(r.first.to_i))
                props[:date_active] << Range.new(date_start, date_end)
              end
            else
              raise MetalArchives::Errors::ParserError, "Unknown token: #{dt.content}"
            end
          end
        end

        props
      end

      def parse_json(response)
        doc = JSON.parse response
      end

      private
        def map_status(status)
          s = {
            nil => '',
            :active => 'Active',
            :split_up => 'Split-up',
            :on_hold => 'On hold',
            :unknown => 'Unknown',
            :changed_name => 'Changed name',
            :disputed => 'Disputed'
          }

          raise MetalArchives::Errors::ParserError, "Unknown status: #{status}" unless s[status]

          s[status]
        end
    end
  end
end
end
