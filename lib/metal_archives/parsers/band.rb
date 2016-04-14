require 'json'
require 'date'
require 'countries'

module MetalArchives
module Parsers
  class Band
    class << self
      def find_endpoint(query)
        "http://www.metal-archives.com/bands/#{query[:name] || ''}/#{query[:id]}"
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
      def map_params(params)
        {
          :bandName => params[:name] || '',
          :exactBandMatch => 0,
          :genre => params[:genre] || '',
          :country => ((params[:country].is_a? ISO3166::Country) ? params[:country].alpha2 : (params[:country] || '')),
          :yearCreationFrom => (params[:year] ? params[:year].begin.year || '' : ''),
          :yearCreationTo => (params[:year] ? params[:year].end.year || '' : ''),
          :bandNotes => params[:comment],
          :status => map_status(params[:status]),
          :themes => params[:lyrical_themes],
          :location => params[:location],
          :bandLabelName => params[:label],
          :indieLabelBand => !!params[:independent]
        }
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
            when 'Current label:'
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
              raise ParserError, "Unknown token: #{dt.content}"
            end
          end
        end

        props
      end

      def parse_json(response)
        props = {}
        doc = JSON.parse response
      end

      private
        def map_status(status)
          return {
            nil => '',
            :active => 'Active',
            :split_up => 'Split-up',
            :on_hold => 'On hold',
            :unknown => 'Unknown',
            :changed_name => 'Changed name',
            :disputed => 'Disputed'
          }[status]
        end
    end
  end
end
end
