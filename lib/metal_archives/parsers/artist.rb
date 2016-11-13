require 'json'
require 'date'
require 'countries'

module MetalArchives
module Parsers
  ##
  # Artist parser
  #
  class Artist # :nodoc:
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
          :query => query[:name] || '',

          :iDisplayStart => query[:iDisplayStart] || 0
        }

        params
      end

      def parse_html(response)
        props = {}
        doc = Nokogiri::HTML response

        doc.css('#member_info dl').each do |dl|
          dl.css('dt').each do |dt|
            case dt.content.strip
            when 'Real/full name:'
              props[:name] = dt.next_element.content.strip
            when 'Age:'
              break if dt.next_element.content == 'N/A'
              date = dt.next_element.content.gsub(/ [0-9]* \(born ([^\)]*)\)/, '\1')
              props[:date_of_birth] = Date.parse date
            when 'R.I.P.:'
              break if dt.next_element.content == 'N/A'
              props[:date_of_death] = Date.parse dt.next_element.content
            when 'Died of:'
              break if dt.next_element.content = 'N/A'
              props[:cause_of_death] = dt.next_element.content
            when 'Place of origin:'
              break if dt.next_element.content == 'N/A'
              props[:country] = ISO3166::Country.find_country_by_name(dt.next_element.css('a').first.content)
              location = dt.next_element.xpath('text()').map { |x| x.content }.join('').strip.gsub(/[()]/, '')
              props[:location] = location unless location.empty?
            when 'Gender:'
              break if dt.next_element.content == 'N/A'
              case dt.next_element.content
              when 'Male'
                props[:gender] = :male
              when 'Female'
                props[:gender] = :female
              else
                raise Errors::ParserError, "Unknown gender: #{dt.next_element.content}"
              end
            else
              raise Errors::ParserError, "Unknown token: #{dt.content}"
            end
          end
        end

        props[:aliases] = []
        alt = doc.css('.band_member_name').first.content
        props[:aliases] << alt unless props[:name] == alt

        props
      rescue => e
        raise ParserError, e
      end

      def parse_links_html(response)
        links = []

        doc = Nokogiri::HTML response

        # Default to official links
        type = :official

        doc.css('#linksTablemain tr').each do |row|
          if row['id'] =~ /^header_/
            type = row['id'].gsub(/^header_/, '').downcase.to_sym
          else
            a = row.css('td a').first
            links << {
                :url => a['href'],
                :type => type,
                :title => a.content
            }
          end
        end

        links
      end
    end
  end
end
end
