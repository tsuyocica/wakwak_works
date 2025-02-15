// ✅ Stimulus をセットアップ
import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// ✅ Stimulus アプリケーションの作成
const application = Application.start();
eagerLoadControllersFrom("./controllers", application);
window.Stimulus = application;

console.log("✅ Stimulus is running:", application);
console.log(
  "✅ Registered Controllers:",
  application.router.modulesByIdentifier
);
console.log("✅ チャンネルインデックスが読み込まれました！");
// ✅ Turbo & Bootstrap の読み込み
import "@hotwired/turbo-rails";
<<<<<<< Updated upstream
import "controllers";
import "channels"
=======
import "./controllers"; // ✅ 修正: 相対パス
import "bootstrap";
import "./channels"; // ✅ 修正: 相対パス
>>>>>>> Stashed changes
