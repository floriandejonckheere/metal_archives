require 'date'

module MetalArchives
module Parsers
  class Label
    class << self
      def find_endpoint(params)
        "http://www.metal-archives.com/labels/#{params[:name]}/#{params[:id]}"
      end

      def parse(response)
        props = {}
        doc = Nokogiri::HTML(response)

        props[:name] = doc.css('#label_info .label_name').first.content

        props[:contact] = []
        doc.css('#label_contact a').each do |contact|
          props[:contact] << {
            :title => contact.content,
            :content => contact.attr(:href)
          }
        end

        doc.css('#label_info dl').each do |dl|
          dl.search('dt').each do |dt|
            case dt.content
            when 'Address:'
              break if dt.next_element.content == 'N/A'
              props[:address] = dt.next_element.content
            when 'Country:'
              break if dt.next_element.content == 'N/A'
              props[:country] = ParserHelper.parse_country dt.next_element.css('a').first.content
            when 'Phone number:'
              break if dt.next_element.content == 'N/A'
              props[:phone] = dt.next_element.content
            when 'Status:'
              props[:status] = dt.next_element.content.downcase.gsub(/ /, '_').to_sym
            when 'Specialised in:'
              break if dt.next_element.content == 'N/A'
              props[:specializations] = ParserHelper.parse_genre dt.next_element.content
            when 'Founding date :'
              break if dt.next_element.content == 'N/A'
              props[:date_founded] = Date.new dt.next_element.content.to_i
            when 'Sub-labels:'
              # TODO
            when 'Online shopping:'
              if dt.next_element.content == 'Yes'
                props[:online_shopping] = true
              elsif dt.next_element.content == 'No'
                props[:online_shopping] = false
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
