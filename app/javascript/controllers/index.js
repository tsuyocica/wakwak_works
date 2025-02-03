// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// 追加
import JobApplicationsController from "./job_applications_controller";
application.register("job-applications", JobApplicationsController);
