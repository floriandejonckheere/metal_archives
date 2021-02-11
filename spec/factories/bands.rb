# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "MetalArchives::Band" do
    id { FFaker::Number.number [1, 2, 3, 4].sample }
    name { FFaker::Name.name }
    status { [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed].sample }

    comment { FFaker::Lorem.words(200).join " " }

    country { ISO3166::Country[FFaker::Address.country_code] }
    location { FFaker::Address.city }

    date_formed { FFaker::Time.date }
    years_active { [2000..2001, 2003..] }

    label { [build(:label), nil].sample }
    independent { label.nil? }

    logo { FFaker::Internet.url }
    photo { FFaker::Internet.url }

    genres do
      Array.new(3) do
        "#{%w(Black Death Doom Power Progressive Speed Thrash).sample} Metal"
      end
    end

    lyrical_themes do
      Array.new(3) do
        [
          "Fantasy",
          "Epic battles",
          "Tales",
          "Myths",
          "Legends",
          "Feelings",
          "Life",
          "Eden",
          "Glory",
          "the Four Elements",
          "Metal",
        ].sample
      end
    end

    similar do
      Array.new(4) do
        {
          band: build(:band),
          score: FFaker::Number.between(1, 100),
        }
      end
    end

    links do
      Array.new(3) do
        {
          url: FFaker::Internet.url,
          type: [:official, :unofficial, :unlisted_bands].sample,
          title: FFaker::Lorem.words(4).join(" "),
        }
      end
    end

    trait :with_aliases do
      aliases do
        Array.new(3) { FFaker::Name.name }
      end
    end
  end
end
