Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations" # カスタムコントローラーを適用
  }
  root "job_posts#index" # ルートページを募集一覧に設定

  # 🔹 ユーザーの役割を切り替えるルート（施工管理者⇔作業員）
  patch "users/switch_role", to: "users#switch_role", as: "switch_role_users"

  resources :users, only: [:show, :edit, :update, :destroy]

  resources :job_posts do # 作業員募集機能
    resources :job_applications, only: [:create, :destroy] # 応募機能は job_post にネスト
  end
end
