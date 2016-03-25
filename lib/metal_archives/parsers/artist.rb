require 'date'

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
        props[:comments] = doc.css('#band_info .band_comment').first.content

        props[:aliases] = []

        doc.css('#band_stats dl').each do |dl|
          dl.search('dt').each do |dt|
            case dt.text
            when 'Country of origin:'
              # TODO
            when 'Location:'
              break if dt.next_element.text == 'N/A'
              props[:location] = dt.next_element.text
            when 'Status:'
              props[:status] = dt.next_element.text.downcase.gsub(/ /, '_').to_sym
            when 'Formed in:'
              break if dt.next_element.text == 'N/A'
              props[:date_formed] = Date.new dt.next_element.text.to_i
            when 'Genre:'
              props[:genres] = []
              break if dt.next_element.text == 'N/A'
              dt.next_element.text.split(',').each do |genre|
                genre.split('/').each do |g|
                  g = genre.split.map(&:capitalize)
                  g.delete 'Metal'
                  g.delete '(later)'
                  g.delete '(early)'
                  props[:genres] << g.join(' ')
                end
              end
            when 'Lyrical themes:'
              props[:themes] = []
              break if dt.next_element.text == 'N/A'
              dt.next_element.text.split(',').each do |theme|
                t = theme.split.map(&:capitalize)
                t.delete '(early)'
                t.delete '(later)'
                props[:themes] << t.join(' ')
              end
            when 'Current label:'
              # TODO
            when 'Years active:'
              break if dt.next_element.text == 'N/A'
              props[:date_active] = []
              dt.next_element.text.split(',').each do |range|
                # Aliases
                names = range.scan(/\(as ([^)]*)\)/).each { |name| props[:aliases] << name.first }
                # Ranges
                range.gsub!(/ *\(as ([^)]*)\) */, '')
                r = range.split('-')
                date_start = (r.first == '?' ? nil : Date.new(r.first.to_i))
                date_end = (r.last == '?' or r.last == 'present' ? nil : Date.new(r.first.to_i))
                props[:date_active] << Range.new(date_start, date_end)
              end
            else
              raise "Unknown token: #{dt.text}"
            end
          end
        end

        props
      end
    end
  end
end
end
