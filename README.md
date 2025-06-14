## usersテーブル

| カラム名              | 型        | 制約                      | 説明               |
|----------------------|-----------|---------------------------|--------------------|
| email                | string    | null: false, unique: true | メールアドレス     |
| encrypted_password   | string    | null: false               | 暗号化パスワード   |
| nickname             | string    | null: false               | ニックネーム       |
| last_name            | string    | null: false               | 姓                 |
| first_name           | string    | null: false               | 名                 |
| last_name_kana       | string    | null: false               | 姓カナ             |
| first_name_kana      | string    | null: false               | 名カナ             |
| birth_date           | date      | null: false               | 生年月日           |

### Association

- has_many :items
- has_many :purchases

---

## itemsテーブル

| カラム名               | 型         | 制約                           | 説明               |
|-----------------------|------------|--------------------------------|--------------------|
| name                  | string     | null: false                    | 商品名             |
| description           | text       | null: false                    | 商品説明           |
| category_id           | integer    | null: false                    | カテゴリー         |
| condition_id          | integer    | null: false                    | 商品状態           |
| shipping_fee_id       | integer    | null: false                    | 配送料の負担       |
| prefecture_id         | integer    | null: false                    | 発送元の地域       |
| shipping_duration_id  | integer    | null: false                    | 発送までの日数     |
| price                 | integer    | null: false                    | 商品価格           |
| user                  | reference  | null: false, foreign_key: true | 出品者（外部キー） |

※ imageはActive Storage等で実装するためテーブルには含めていません

### Association

- belongs_to :user
- has_one :purchase

---

## purchasesテーブル

| カラム名      | 型        | 制約                           | 説明               |
|--------------|-----------|--------------------------------|--------------------|
| item         | reference | null: false, foreign_key: true | 商品（外部キー）    |
| user         | reference | null: false, foreign_key: true | 購入者（外部キー）  |

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

---

## addressesテーブル

| カラム名         | 型        | 制約                           | 説明               |
|-----------------|-----------|--------------------------------|--------------------|
| postal_code     | string    | null: false                    | 郵便番号           |
| prefecture_id   | integer   | null: false                    | 都道府県           |
| city            | string    | null: false                    | 市区町村           |
| address         | string    | null: false                    | 番地               |
| building        | string    |                                | 建物名・号室       |
| phone_number    | string    | null: false                    | 電話番号           |
| purchase        | reference | null: false, foreign_key: true | 購入者（外部キー） |

※ クレジットカード情報はStripeやPayPal等の外部決済サービスを活用する想定のためテーブルには含めていません

### Association

- belongs_to :purchase