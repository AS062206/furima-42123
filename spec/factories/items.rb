FactoryBot.define do
  factory :item do
    name              { 'テスト' }
    description       { 'テスト_説明' }
    price             { 1000 }

    category_id        { 2 } # メンズ
    condition_id       { 2 } # 新品・未使用
    shipping_fee_id    { 2 } # 着払い(購入者負担)
    prefecture_id      { 2 } # 北海道
    shipping_duration_id { 2 } # 1~2日で発送

    association :user

    after(:build) do |message|
      message.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
