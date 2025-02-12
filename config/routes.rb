Rails.application.routes.draw do
  mount ActionCable.server => '/cable' # ✅ WebSocketのエンドポイントを設定

  devise_for :users, controllers: {
    registrations: "users/registrations" # カスタムコントローラーを適用
  }
  root "job_posts#index" # ルートページを募集一覧に設定

  # ユーザーの役割を切り替えるルート（施工管理者⇔作業員）
  patch "users/switch_role", to: "users#switch_role", as: "switch_role_users"

  resources :users, only: [:show, :edit, :update, :destroy]

  resources :job_posts do # 作業員募集機能
    resources :job_applications, only: [:create, :destroy] do
      member do
        patch :approve  # 応募者を承認（非同期処理用）
        patch :reject   # 応募者を却下（非同期処理用）
        patch :update_status # 応募の状態を更新（非同期処理用）
      end
    end

    member do
      get :applicants  # 応募者一覧ページ（施工管理者用）
    end
  end

  # **チャット機能のルート**
  resources :chats, only: [:index, :show, :create] do
    resources :messages, only: [:create] # メッセージ送信
  end
end