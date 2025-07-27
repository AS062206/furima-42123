require 'rails_helper'

RSpec.describe PurchaseAddress, type: :form do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, user: FactoryBot.create(:user))
  end

  before do
    allow(Payjp::Charge).to receive(:create).and_return(double('charge', id: 'ch_test_id'))
  end

   describe '購入情報の保存' do
    context '購入できる場合' do
      # --- すべての情報が正しく入力されている場合 ---
      it 'すべての情報が正しく入力されていれば保存できる' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id)
        )
        expect(purchase_address).to be_valid
        
        expect { purchase_address.save }.to change { Purchase.count }.by(1).and change { Address.count }.by(1)
        
        purchase = Purchase.last
        expect(purchase.item_id).to eq(@item.id)
        expect(purchase.user_id).to eq(@user.id)
        
        address = Address.last
        expect(address.postal_code).to eq(FactoryBot.attributes_for(:purchase_address)[:postal_code])
        expect(address.prefecture_id).to eq(FactoryBot.attributes_for(:purchase_address)[:prefecture_id])
        expect(address.city).to eq(FactoryBot.attributes_for(:purchase_address)[:city])
        expect(address.address).to eq(FactoryBot.attributes_for(:purchase_address)[:address])
        expect(address.phone_number).to eq(FactoryBot.attributes_for(:purchase_address)[:phone_number])
        expect(address.purchase_id).to eq(purchase.id)
      end

      # --- 建物名が任意であることのテスト ---
      it '建物名が空でも保存できる' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, building: '')
        )
        expect(purchase_address).to be_valid
        expect { purchase_address.save }.to change { Purchase.count }.by(1).and change { Address.count }.by(1)
        expect(Address.last.building).to be_empty
      end
    end

    context '購入できない場合' do
      # --- PAY.JPトークンに関するバリデーション ---
      it 'tokenが空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, token: '')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Token can't be blank")
      end

      # --- PAY.JP決済が失敗するケース ---
      it 'PAY.JP決済が失敗した場合は保存できない' do
        allow(Payjp::Charge).to receive(:create).and_raise(Payjp::PayjpError.new('Test payment failed by mock'))
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id)
        )
        expect(purchase_address.valid?).to be_truthy 
        expect(purchase_address.save).to be_falsey
        expect { purchase_address.save }.to change { Purchase.count }.by(0).and change { Address.count }.by(0)
        expect(purchase_address.errors.full_messages).to include("決済に失敗しました: Test payment failed by mock")
      end

      # --- 配送先住所情報のバリデーション ---
      it '郵便番号が空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, postal_code: '')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Postal code can't be blank")
      end

      it '郵便番号にハイフンがないと保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, postal_code: '1234567')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Postal code is invalid. Enter it as follows (e.g., 123-4567)")
      end

      it '郵便番号が半角文字列以外（全角数字や記号など）では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, postal_code: '１２３-４５６７')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Postal code is invalid. Enter it as follows (e.g., 123-4567)")

        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, postal_code: 'abc-defg')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Postal code is invalid. Enter it as follows (e.g., 123-4567)")
      end

      it '都道府県が---（id:1）では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, prefecture_id: 1)
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Prefecture can't be blank")
      end

      it '市区町村が空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, city: '')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("City can't be blank")
      end

      it '番地が空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, address: '')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Address can't be blank")
      end

      it '電話番号が空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, phone_number: '')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Phone number can't be blank")
      end

      it '電話番号が9桁以下では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, phone_number: '090123456')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Phone number is invalid. Enter only numbers")
      end

      it '電話番号が12桁以上では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, phone_number: '090123456789')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Phone number is invalid. Enter only numbers")
      end

      it '電話番号に半角数字以外が含まれていると保存できない（ハイフン含む）' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, phone_number: '090-1234-5678')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Phone number is invalid. Enter only numbers")
        
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: @user.id, phone_number: '090abcdefgh')
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Phone number is invalid. Enter only numbers")
      end
      
      # --- 外部キー（User, Item）に関するバリデーション ---
      it 'user_idが空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: @item.id, user_id: nil)
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空では保存できない' do
        purchase_address = PurchaseAddress.new(
          FactoryBot.attributes_for(:purchase_address, item_id: nil, user_id: @user.id)
        )
        expect(purchase_address).to be_invalid
        expect(purchase_address.errors.full_messages).to include("Item can't be blank")
      end

      # --- すべての必須項目が空の場合の包括的テスト ---
      it 'item_idとuser_idは存在するが、それ以外がすべて空では保存できない' do
        all_blank_except_ids_params = FactoryBot.attributes_for(:purchase_address, 
                                          item_id: @item.id, 
                                          user_id: @user.id,
                                          postal_code: '', 
                                          prefecture_id: 1,
                                          city: '', 
                                          address: '', 
                                          building: '',
                                          phone_number: '', 
                                          token: '')
        purchase_address = PurchaseAddress.new(all_blank_except_ids_params)
        expect(purchase_address).to be_invalid
        
        expect(purchase_address.errors.full_messages).to include("Postal code can't be blank")
        expect(purchase_address.errors.full_messages).to include("Prefecture can't be blank")
        expect(purchase_address.errors.full_messages).to include("City can't be blank")
        expect(purchase_address.errors.full_messages).to include("Address can't be blank")
        expect(purchase_address.errors.full_messages).to include("Phone number can't be blank")
        expect(purchase_address.errors.full_messages).to include("Token can't be blank")
      end
    end
  end
end