# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "MetalArchives::Band" do
    id { FFaker::Number.number [1, 2, 3, 4].sample }
    name { FFaker::Name.name }
    status { %i(active split_up on_hold unknown changed_name disputed).sample }

    comment { FFaker::Lorem.words(200).join " " }

    country { ISO3166::Country[FFaker::Address.country_code] }
    location { FFaker::Address.city }

    date_formed { FFaker::Time.date }
    date_active { build_list :range }

    label { [build(:label), nil].sample }
    independent { label.nil? }

    logo { FFaker::Internet.url }
    photo { FFaker::Internet.url }

    genres do
      3.times.collect do
        "#{%w(Black Death Doom Power Progressive Speed Thrash).sample} Metal"
      end
    end

    lyrical_themes do
      3.times.collect do
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
      4.times.collect do
        {
          band: build(:band),
          score: FFaker::Number.between(1, 100),
        }
      end
    end

    links do
      3.times.collect do
        {
          url: FFaker::Internet.url,
          type: %i(official unofficial unlisted_bands).sample,
          title: FFaker::Lorem.words(4).join(" "),
        }
      end
    end

    trait :with_aliases do
      aliases do
        3.times.collect { FFaker::Name.name }
      end
    end
  end
end
