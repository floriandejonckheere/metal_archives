module MetalArchives
module Parser
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
        doc.css('#band_stats dl').each do |dl|
          dl.search('dt').each do |dt|

          end
        end

        props
      end
    end
  end
end
end
