# frozen_string_literal: true

FactoryBot.define do
  factory :range, class: "MetalArchives::Range" do
    send(:begin) { FFaker::Time.date }
    send(:end) { FFaker::Time.date }
  end
end
