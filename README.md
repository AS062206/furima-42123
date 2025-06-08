## usersテーブル

| カラム名              | 型        | 制約             | 説明               |
|----------------------|-----------|------------------|--------------------|
| email                | string    | NOT NULL, UNIQUE | メールアドレス     |
| encrypted_password   | string    | NOT NULL         | 暗号化パスワード   |
| nickname             | string    | NOT NULL, UNIQUE | ニックネーム       |
| last_name            | string    | NOT NULL         | 姓                 |
| first_name           | string    | NOT NULL         | 名                 |
| last_name_kana       | string    | NOT NULL         | 姓カナ             |
| first_name_kana      | string    | NOT NULL         | 名カナ             |
| birth_date           | date      | NOT NULL         | 生年月日           |

---

## itemsテーブル

| カラム名            | 型        | 制約        | 説明               |
|--------------------|-----------|----------|--------------------|
| name               | string    | NOT NULL | 商品名             |
| description        | text      | NOT NULL | 商品説明           |
| category           | string    | NOT NULL | カテゴリー         |
| condition          | string    | NOT NULL | 商品状態           |
| shipping_fee       | string    | NOT NULL | 配送料の負担       |
| shipping_origin    | string    | NOT NULL | 発送元の地域       |
| shipping_duration  | string    | NOT NULL | 発送までの日数     |
| price              | integer   | NOT NULL | 商品価格           |
| user_id            | reference | NOT NULL | 出品者（外部キー） |

※ imageはActive Storage等で実装するためテーブルには含めていません

---

## purchasesテーブル

| カラム名         | 型        | 制約     | 説明               |
|-----------------|-----------|----------|--------------------|
| postal_code     | string    | NOT NULL | 郵便番号           |
| prefecture      | string    | NOT NULL | 都道府県           |
| city            | string    | NOT NULL | 市区町村           |
| address         | string    | NOT NULL | 番地               |
| building        | string    | NOT NULL | 建物名・号室       |
| phone_number    | string    | NOT NULL | 電話番号           |
| order_date      | datetime  | NOT NULL | 注文日時           |
| item_id         | reference | NOT NULL | 商品（外部キー）   |
| user_id         | reference | NOT NULL | 購入者（外部キー） |

※ クレジットカード情報はStripeやPayPal等の外部決済サービスを活用する想定のためテーブルには含めていません