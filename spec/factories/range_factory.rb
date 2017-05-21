# frozen_string_literal: true

FactoryGirl.define do
  factory :range do
    _begin { Faker::Date.birthday 0, 50 }
    _end { Faker::Date.birthday _begin, Date.today}
  end
end
