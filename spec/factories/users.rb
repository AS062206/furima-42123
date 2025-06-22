FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.unique.email }
    password              { Faker::Internet.password(min_length: 6, max_length: 128, mix_case: true, special_characters: false) + '1a' }
    password_confirmation { password }
    nickname              { Faker::Name }
    last_name             { Gimei.last.kanji }
    first_name            { Gimei.first.kanji }
    last_name_kana        { Gimei.last.katakana }
    first_name_kana       { Gimei.first.katakana }
    birth_date            { Faker::Date.birthday(min_age: 5, max_age: 100) }
  end
end