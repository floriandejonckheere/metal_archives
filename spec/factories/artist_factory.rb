# frozen_string_literal: true

FactoryGirl.define do
  factory :artist, :class => MetalArchives::Artist do
    id { Faker::Number.number [1, 2, 3, 4].sample }
    name { Faker::Name.name }
    gender { %i[male female].sample }
    biography { Faker::Lorem.words(200).join ' ' }
    trivia { Faker::Lorem.words(200).join ' ' }

    country { ISO3166::Country[Faker::Address.country_code] }
    location { Faker::Address.city }

    date_of_birth { Faker::Date.birthday 18, 65 }

    links do
      3.times.collect do
        {
          :url => Faker::Internet.url,
          :type => %i[official unofficial unlisted_bands].sample,
          :title => Faker::Lorem.words(4).join(' ')
        }
      end
    end

    trait :has_died do
      date_of_death { Faker::Date.between date_of_birth, Date.today }
      cause_of_death { %w(Suicide N/A Accident Cancer Illness Murder).sample }
    end

    trait :with_aliases do
      aliases do
        3.times.collect { Faker::Name.name }
      end
    end
  end
end
