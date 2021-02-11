# frozen_string_literal: true

require "date"
require "nokogiri"

module MetalArchives
  module Parsers
    ##
    # Label parser
    #
    class Label # :nodoc:
      class << self
        def find_endpoint(params)
          "#{MetalArchives.config.endpoint}labels/#{params[:name]}/#{params[:id]}"
        end

        def parse(response)
          # Set default props
          props = {
            name: nil,
            contact: [],
            address: nil,
            country: nil,
            phone: nil,
            status: nil,
            specialization: [],
            date_founded: nil,

            online_shopping: nil,
          }

          doc = Nokogiri::HTML(response)

          props[:name] = doc.css("#label_info .label_name").first.content

          doc.css("#label_contact a").each do |contact|
            props[:contact] << {
              title: contact.content,
              content: contact.attr(:href),
            }
          end

          doc.css("#label_info dl").each do |dl|
            dl.search("dt").each do |dt|
              content = sanitize(dt.next_element.content)

              next if content == "N/A"

              case sanitize(dt.content)
              when "Address:"
                props[:address] = content
              when "Country:"
                props[:country] = Country.parse(css("a").first.content)
              when "Phone number:"
                props[:phone] = content
              when "Status:"
                props[:status] = content.downcase.tr(" ", "_").to_sym
              when "Specialised in:"
                props[:specializations] = ParserHelper.parse_genre content
              when "Founding date :"
                props[:date_founded] = parse_date content
              when "Sub-labels:"
                # TODO
              when "Online shopping:"
                case content
                when "Yes"
                  props[:online_shopping] = true
                when "No"
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
