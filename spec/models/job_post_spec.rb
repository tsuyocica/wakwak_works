require 'rails_helper'

RSpec.describe JobPost, type: :model do
  describe 'バリデーションのテスト' do
    let(:job_post) { build(:job_post) }

    context '作業案件が登録できる場合' do
      it '全ての属性が有効な場合、job_post を作成できる' do
        expect(job_post).to be_valid
      end
    end

    context '作業案件が登録できない場合' do
      it '「作業案件」が空だと無効' do
        job_post.work_title = ''
        expect(job_post).not_to be_valid
      end

      it '「作業案件」が40文字を超えると無効' do
        job_post.work_title = 'a' * 41
        expect(job_post).not_to be_valid
      end

      it '「作業内容」が空だと無効' do
        job_post.work_description = ''
        expect(job_post).not_to be_valid
      end

      it '「作業内容」が2000文字を超えると無効' do
        job_post.work_description = 'a' * 2001
        expect(job_post).not_to be_valid
      end

      it '「募集人員」が空だと無効' do
        job_post.work_capacity = nil
        expect(job_post).not_to be_valid
      end

      it '「募集人員」が0以下だと無効' do
        job_post.work_capacity = 0
        expect(job_post).not_to be_valid
      end

      it '「募集人員」が11以上だと無効' do
        job_post.work_capacity = 11
        expect(job_post).not_to be_valid
      end

      it '「作業開始日」が空だと無効' do
        job_post.work_start_date = nil
        expect(job_post).not_to be_valid
      end

      it '「作業開始日」が今日以前だと無効' do
        job_post.work_start_date = Date.today
        expect(job_post).not_to be_valid
      end

      it '「作業終了日」が空だと無効' do
        job_post.work_end_date = nil
        expect(job_post).not_to be_valid
      end

      it '「作業終了日」が work_start_date より前だと無効' do
        job_post.work_start_date = Date.tomorrow
        job_post.work_end_date = Date.today
        expect(job_post).not_to be_valid
      end

      it '「報酬」が空だと無効' do
        job_post.work_payment = nil
        expect(job_post).not_to be_valid
      end

      it '「報酬」が20,000円未満だと無効' do
        job_post.work_payment = 19_999
        expect(job_post).not_to be_valid
      end

      it '「報酬」が9,999,999円を超えると無効' do
        job_post.work_payment = 10_000_000
        expect(job_post).not_to be_valid
      end

      it 'work_location が空だと無効' do
        job_post.work_location = ''
        expect(job_post).not_to be_valid
      end

      it '「募集状況」が空だと無効' do
        job_post.work_status = nil
        expect(job_post).not_to be_valid
      end

      it '「募集状況」が "recruiting" または "closed" 以外だと無効' do
        job_post.work_status = 'invalid_status'
        expect(job_post).not_to be_valid
      end
    end

    context 'アバターのバリデーション' do
      it 'メイン画像が JPEG または PNG の場合、有効' do
        job_post.main_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png')
        expect(job_post).to be_valid
      end

      it 'メイン画像が 5MB を超える場合、無効' do
        job_post.main_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/large_image.jpg'), 'image/jpeg')
        expect(job_post).not_to be_valid
      end

      it 'メイン画像が許可されていない拡張子の場合、無効' do
        job_post.main_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.gif'), 'image/gif')
        expect(job_post).not_to be_valid
      end
    end
  end
end