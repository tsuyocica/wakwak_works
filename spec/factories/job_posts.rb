FactoryBot.define do
  factory :job_post do
    association :user  # 施工管理者の関連付け
    work_title { Faker::Job.title }
    work_description { Faker::Lorem.paragraph(sentence_count: 5) }
    work_capacity { rand(1..10) }
    work_start_date { Date.tomorrow }
    work_end_date { Date.tomorrow + rand(1..7).days }
    work_payment { rand(20_000..9_999_999) }
    work_location { "東京都千代田区千代田1-1" }
    work_status { "recruiting" }

    # メイン画像を設定（JPEG形式）
    main_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }
  end
end