// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// job_post/applicantsビューの承認後に”チャットを開く”を表示
import JobApplicationsController from "./job_applications_controller";
application.register("job-applications", JobApplicationsController);

// job_post/indexビューの表示切り替え
import ToggleViewController from "./toggle_view_controller";
application.register("toggle-view", ToggleViewController);

// job_post/new、showビューページの画像プレビュー & ファイルプレビュー
import ImagePreviewController from "./image_preview_controller";
application.register("image-preview", ImagePreviewController);
