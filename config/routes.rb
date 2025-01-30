Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations" # カスタムコントローラーを適用
  }
  root "job_posts#index" # ルートページを募集一覧に設定

  resources :users, only: [:show, :edit, :update, :destroy] do
    member do
      get :show_manager  # 施工管理者マイページページ
      get :show_worker   # 作業員マイページページ
    end
  end

  resources :job_posts do # 作業員募集機能
    resources :job_applications, only: [:create] # 応募処理は job_post にネスト
  end
end
