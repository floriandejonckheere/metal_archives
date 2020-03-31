# frozen_string_literal: true

FactoryGirl.define do
  factory :range, class: MetalArchives::Range do
    send(:begin) { FFaker::Date.birthday 0, 50 }
    send(:end) { FFaker::Date.birthday }
  end
end
