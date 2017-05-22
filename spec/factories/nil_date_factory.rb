# frozen_string_literal: true

FactoryGirl.define do
  factory :nil_date, :class => MetalArchives::NilDate do
    year { Faker::Date.backward(99).year }
    month { Faker::Date.backward(99).month }
    day { Faker::Date.backward(99).day }
  end
end
