// ✅ Stimulus をセットアップ
import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// ✅ Stimulus アプリケーションの作成
const application = Application.start();
eagerLoadControllersFrom("./controllers", application);

// ✅ Turbo & Bootstrap の読み込み
import "@hotwired/turbo-rails";
import "controllers";
import "bootstrap";
import "channels";
