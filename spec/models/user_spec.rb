require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }

    context '有効なユーザー' do
      it '全ての属性が有効である場合、ユーザーが作成できる' do
        expect(user).to be_valid
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
        user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.jpg'), 'image/jpeg')
        expect(user).to be_valid
      end

      it 'アバターが 5MB を超える場合、無効' do
        user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/large_image.jpg'), 'image/jpeg')
        expect(user).not_to be_valid
        expect(user.errors[:avatar]).to include("のサイズは5MB以下にしてください")
      end

      it 'アバターが許可されていない拡張子の場合、無効' do
        user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.gif'), 'image/gif')
        expect(user).not_to be_valid
        expect(user.errors[:avatar]).to include("はJPEGまたはPNG形式のみアップロードできます")
      end
    end
  end
end