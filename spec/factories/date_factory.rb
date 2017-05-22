# frozen_string_literal: true

FactoryGirl.define do
  factory :date, :class => MetalArchives::Date do
    year { Faker::Date.backward(99).year }
    month { Faker::Date.backward(99).month }
    day { Faker::Date.backward(99).day }
  end
end
