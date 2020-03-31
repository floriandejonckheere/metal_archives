# frozen_string_literal: true

FactoryGirl.define do
  factory :nil_date, class: "MetalArchives::NilDate" do
    year { FFaker::Date.backward(99).year }
    month { FFaker::Date.backward(99).month }
    day { FFaker::Date.backward(99).day }
  end
end
