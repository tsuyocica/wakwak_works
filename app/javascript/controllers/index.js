// import { application } from "controllers/application";
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// // ✅ Stimulus の動作確認用ログ（追加！）
// console.log("Stimulus is running:", application);
// console.log("Registered controllers:", application.router.modulesByIdentifier);

// // すべてのコントローラーを自動ロード
// eagerLoadControllersFrom("controllers", application);

// // 👇 **手動でコントローラーを登録する**
// import AvatarPreviewController from "./avatar_preview_controller";
// import ImagePreviewController from "./image_preview_controller";
// import JobApplicationsController from "./job_applications_controller";
// import ToggleViewController from "./toggle_view_controller";

// application.register("avatar-preview", AvatarPreviewController);
// application.register("image-preview", ImagePreviewController);
// application.register("job-applications", JobApplicationsController);
// application.register("toggle-view", ToggleViewController);

// // デバッグ情報を確認
// console.log("Stimulus initialized:", application);
// window.Stimulus = application;
