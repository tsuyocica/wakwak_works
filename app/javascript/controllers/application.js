import { Application } from "@hotwired/stimulus";

// Stimulusの初期化
const application = Application.start();

// Stimulus をデバッグモード OFF（必要なら true に変更）
application.debug = false;

// グローバル変数として Stimulus を利用可能にする（デバッグ用）
window.Stimulus = application;

export { application };
