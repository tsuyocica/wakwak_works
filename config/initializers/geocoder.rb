Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API_KEY'],  # 環境変数に APIキーを保存
  use_https: true,
  timeout: 5,  # API のタイムアウト時間
  units: :km,  # 距離を km で計算
  language: :ja,  # 日本語の住所を取得
)