# frozen_string_literal: true

FactoryGirl.define do
  factory :range, :class => MetalArchives::Range do
    send(:begin) { Faker::Date.birthday 0, 50 }
    send(:end) { Faker::Date.birthday }
  end
end
