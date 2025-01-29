Rails.application.routes.draw do
  devise_for :users
  root "job_posts#index" # ルートページを募集一覧に設定

  resources :users, only: [:show] do # マイページ用
    member do
      # get :show_owner  # 依頼者用ページ
      # get :show_worker # 作業員用ページ
    end
  end

  resources :job_posts, only: [:index, :show, :new, :create] do # 作業員募集機能
    resources :job_applications, only: [:create] # 応募処理は job_post にネスト
  end
end
