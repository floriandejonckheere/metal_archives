# frozen_string_literal: true

FactoryGirl.define do
  factory :artist, class: "MetalArchives::Artist" do
    id { FFaker::Number.number [1, 2, 3, 4].sample }
    name { FFaker::Name.name }
    gender { %i(male female).sample }
    biography { FFaker::Lorem.words(200).join " " }
    trivia { FFaker::Lorem.words(200).join " " }

    country { ISO3166::Country[FFaker::Address.country_code] }
    location { FFaker::Address.city }

    date_of_birth { FFaker::Date.birthday 18, 65 }

    links do
      3.times.collect do
        {
          url: FFaker::Internet.url,
          type: %i(official unofficial unlisted_bands).sample,
          title: FFaker::Lorem.words(4).join(" "),
        }
      end
    end

    trait :has_died do
      date_of_death { FFaker::Date.between date_of_birth, Date.today }
      cause_of_death { %w(Suicide N/A Accident Cancer Illness Murder).sample }
    end

    trait :with_aliases do
      aliases do
        3.times.collect { FFaker::Name.name }
      end
    end
  end
end
