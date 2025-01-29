class JobPostsController < ApplicationController
  def index
    @job_posts = JobPost.where(work_status: "recruiting").order(created_at: :desc) # 募集中の案件を表示
  end

  def show
    @job_post = JobPost.find(params[:id]) # URLのIDから案件を取得
  end
end
