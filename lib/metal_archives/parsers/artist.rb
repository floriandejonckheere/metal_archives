require 'date'
require 'countries'

module MetalArchives
module Parsers
  class Artist
    class << self
      def find_endpoint(params)
        "http://www.metal-archives.com/bands/#{params[:name]}/#{params[:id]}"
      end

      def parse(response)
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
              raise "Unknown token: #{dt.content}"
            end
          end
        end

        props
      end
    end
  end
end
end
