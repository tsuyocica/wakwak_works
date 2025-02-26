require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }

    context 'ユーザー新規登録できる場合' do
      it '全ての属性が有効である場合、ユーザーが作成できる' do
        expect(user).to be_valid
      end
    end

    context 'ユーザー新規登録できない場合' do
      it 'ユーザー名が空だと無効' do
        user.username = ''
        expect(user).not_to be_valid
      end

      it 'ユーザー名が3文字未満だと無効' do
        user.username = 'aa'
        expect(user).not_to be_valid
      end

      it 'ユーザー名が20文字を超えると無効' do
        user.username = 'a' * 21
        expect(user).not_to be_valid
      end

      it 'メールが空だと無効' do
        user.email = ''
        expect(user).not_to be_valid
      end

      it 'メールのフォーマットが不正だと無効' do
        user.email = 'invalid_email'
        expect(user).not_to be_valid
      end

      it 'メールが一意でないと無効' do
        create(:user, email: 'test@example.com')  # 既存ユーザーを作成
        user.email = 'test@example.com'
        expect(user).not_to be_valid
      end

      it 'full_name が2文字未満だと無効' do
        user.full_name = 'A'
        expect(user).not_to be_valid
      end

      it 'full_name が30文字を超えると無効' do
        user.full_name = 'A' * 31
        expect(user).not_to be_valid
      end

      it 'ふりがなが空だと無効' do
        user.furigana = ''
        expect(user).not_to be_valid
      end

      it 'ふりがながカタカナを含むと無効' do
        user.furigana = 'タナカタロウ'
        expect(user).not_to be_valid
      end

      it 'ふりがなが漢字を含むと無効' do
        user.furigana = '田中太郎'
        expect(user).not_to be_valid
      end

      it 'ふりがなが英数字を含むと無効' do
        user.furigana = 'tanaka123'
        expect(user).not_to be_valid
      end

      it '生年月日が空だと無効' do
        user.birth_date = nil
        expect(user).not_to be_valid
      end

      it '18歳未満だと無効' do
        user.birth_date = 17.years.ago
        expect(user).not_to be_valid
      end

      it '役割が空だと無効' do
        user.role = nil
        expect(user).not_to be_valid
      end

      it '役割が不正な値だと無効' do
        user.role = 'エンジニア'
        expect(user).not_to be_valid
      end

      it '経験が空だと無効' do
        user.experience = ''
        expect(user).not_to be_valid
      end

      it '経験が2000文字を超えると無効' do
        user.experience = 'a' * 2001
        expect(user).not_to be_valid
      end

      it '資格が空だと無効' do
        user.qualification = ''
        expect(user).not_to be_valid
      end

      it '資格が50文字を超えると無効' do
        user.qualification = 'a' * 51
        expect(user).not_to be_valid
      end
    end

    context 'パスワードのバリデーション' do
      it 'パスワードが6文字以上で半角英数字を含む場合、有効である' do
        user.password = 'abc123'
        expect(user).to be_valid
      end

      it 'パスワードが5文字以下だと無効' do
        user.password = 'abc12'
        expect(user).not_to be_valid
      end

      it 'パスワードが英字のみだと無効' do
        user.password = 'abcdef'
        expect(user).not_to be_valid
      end

      it 'パスワードが数字のみだと無効' do
        user.password = '123456'
        expect(user).not_to be_valid
      end

      it 'パスワードに記号が含まれると無効' do
        user.password = 'abc123!'
        expect(user).not_to be_valid
      end
    end

    context 'アバターのバリデーション' do
      it 'アバターが JPEG または PNG の場合、有効' do
        user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.png'), 'image/png')
        expect(user).to be_valid
      end

      it 'アバターが 5MB を超える場合、無効' do
        user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/large_image.jpg'), 'image/jpeg')
        expect(user).not_to be_valid
      end

      it 'アバターが許可されていない拡張子の場合、無効' do
        user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.gif'), 'image/gif')
        expect(user).not_to be_valid
      end
    end
  end
end