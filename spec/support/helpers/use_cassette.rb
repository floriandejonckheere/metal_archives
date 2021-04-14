# frozen_string_literal: true

module UseCassette
  def use_cassette!(name)
    around { |example| VCR.use_cassette(name, re_record_interval: 1.month, &example) }
  end
end

RSpec.configure do |config|
  config.include UseCassette
end
