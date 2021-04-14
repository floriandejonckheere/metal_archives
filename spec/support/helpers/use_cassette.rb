# frozen_string_literal: true

module UseCassette
  def use_cassette!(name, **options)
    options = { re_record_interval: 1.month }.merge(options)
    around { |example| VCR.use_cassette(name, **options, &example) }
  end
end

RSpec.configure do |config|
  config.extend UseCassette
end
