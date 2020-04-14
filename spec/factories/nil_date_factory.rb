# frozen_string_literal: true

FactoryBot.define do
  factory :nil_date, class: "MetalArchives::NilDate" do
    year { FFaker::Time.date.year }
    month { FFaker::Time.date.month }
    day { FFaker::Time.date.day }
  end
end
