require 'rails_helper'

RSpec.describe User, type: :model do
require 'pry'

  before do
    @user = FactoryBot.build(:user)
  end

  # 新規登録/ユーザー情報 #
  describe 'ユーザー新規登録機能' do
    context '新規登録できる場合' do
      it "すべてのテーブル情報が満たされている" do
        expect(@user).to be_valid
      end
    end
    context 'ユーザー新規登録ができない' do
      # 'ニックネームのバリデーションテスト'
      it 'ニックネームが空では登録できない' do
        @user.nickname = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      # 'メールアドレスのバリデーションテスト'
      it 'メールアドレスが空では登録できない' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it '重複したメールアドレスでは登録できない' do
        FactoryBot.create(:user, email: 'test@example.com')
        @user.email = 'test@example.com'
        @user.valid?
        expect(@user.errors.full_messages).to include("Email has already been taken")
      end
      it 'メールアドレスに@が含まれていないと登録できない' do
        @user.email = 'testexample.com'
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
      it '無効な形式のメールアドレスでは登録できない' do
        ['test@', '@example.com', 'test.com'].each do |email|
          @user.email = email
          @user.valid?
          expect(@user.errors.full_messages).to include("Email is invalid")
        end
      end
      
      # 'パスワードのバリデーションテスト'
      it 'パスワードが空では登録できない' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank", "Password confirmation doesn't match Password", "Password is invalid")
      end
      it 'パスワードが5文字以下では登録できない' do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'パスワードが数字のみでは登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it 'パスワードが英字のみでは登録できない' do
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it 'パスワードに全角文字が含まれていると登録できない' do
        @user.password = 'ａｂｃ１２３'
        @user.password_confirmation = 'ａｂｃ１２３'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it 'パスワードとパスワード（確認）が一致しないと登録できない' do
        @user.password = 'pass123'
        @user.password_confirmation = 'pass456'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      
      # '名前（全角）のバリデーションテスト'
      it '名字が空では登録できない' do
        @user.last_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank", "Last name is invalid")
      end
      it '名前が空では登録できない' do
        @user.first_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank", "First name is invalid")
      end
      it '名字に半角文字が含まれていると登録できない' do
        @user.last_name = 'Yamada'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name is invalid")
      end
      # '名前カナ（全角）のバリデーションテスト'
      it '名字カナが空では登録できない' do
        @user.last_name_kana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana can't be blank", "Last name kana is invalid")
      end
      it '名前カナが空では登録できない' do
        @user.first_name_kana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana can't be blank", "First name kana is invalid")
      end
      it '名字カナに全角ひらがな、漢字、半角文字が含まれていると登録できない' do
        @user.last_name_kana = 'やまだ'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana is invalid")
        @user.last_name_kana = '山田'
        expect(@user.errors.full_messages).to include("Last name kana is invalid")
        @user.last_name_kana = 'yamada'
        expect(@user.errors.full_messages).to include("Last name kana is invalid")
      end
      # '生年月日のバリデーションテスト'
      it '生年月日が空では登録できない' do
        @user.birth_date = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth date can't be blank")
      end
    end
  end
end