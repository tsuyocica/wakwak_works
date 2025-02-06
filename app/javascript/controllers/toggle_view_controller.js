import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "toggleButton"];

  connect() {
    this.viewMode = "card"; // 初期表示はカード形式
    this.toggleViewState(false);
  }

  switchView() {
    this.viewMode = this.viewMode === "card" ? "table" : "card";
    this.toggleViewState(this.viewMode === "table");
  }

  toggleViewState(isTable) {
    const cardView = document.querySelector("#card-view");
    const tableView = document.querySelector("#table-view");

    if (!cardView || !tableView) return;

    if (isTable) {
      cardView.hidden = true;
      tableView.hidden = false;
      this.toggleButtonTarget.textContent = "カード形式で表示";
    } else {
      cardView.hidden = false;
      tableView.hidden = true;
      this.toggleButtonTarget.textContent = "テーブル形式で表示";
    }
  }
}
