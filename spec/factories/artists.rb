# frozen_string_literal: true

FactoryBot.define do
  factory :artist, class: "MetalArchives::Artist" do
    id { FFaker::Number.number [1, 2, 3, 4].sample }
    name { FFaker::Name.name }
    gender { [:male, :female].sample }
    biography { FFaker::Lorem.words(200).join " " }
    trivia { FFaker::Lorem.words(200).join " " }

    country { ISO3166::Country[FFaker::Address.country_code] }
    location { FFaker::Address.city }

    date_of_birth { FFaker::Time.date }

    links do
      Array.new(3) do
        {
          url: FFaker::Internet.url,
          type: [:official, :unofficial, :unlisted_bands].sample,
          title: FFaker::Lorem.words(4).join(" "),
        }
      end
    end

    trait :has_died do
      date_of_death { FFaker::Time.between date_of_birth, Date.today }
      cause_of_death { %w(Suicide N/A Accident Cancer Illness Murder).sample }
    end

    trait :with_aliases do
      aliases do
        Array.new(3) { FFaker::Name.name }
      end
    end
  end
end
