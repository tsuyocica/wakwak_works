// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// 追加
import JobApplicationsController from "./job_applications_controller";
application.register("job-applications", JobApplicationsController);

// job_post/indexビューの表示切り替え
import ToggleViewController from "./toggle_view_controller";
application.register("toggle-view", ToggleViewController);
