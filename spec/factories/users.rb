FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..15) }
    email { Faker::Internet.email }
    password { "password123" }
    full_name { "田中太郎" }
    furigana { "たなかたろう" }
    birth_date { 20.years.ago }
    role { ["施工管理者", "作業員"].sample }
    experience { Faker::Lorem.sentence(word_count: 10) }
    qualification { Faker::Job.title }

    # テスト用のアバター画像をセット
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_avatar.png'), 'image/png') }
  end
end