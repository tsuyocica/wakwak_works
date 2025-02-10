import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mainImageInput", "mainImagePreview"];

  connect() {
    // 既に画像がある場合、プレビューを表示
    if (this.mainImagePreviewTarget.dataset.imageUrl) {
      this.setMainImage(this.mainImagePreviewTarget.dataset.imageUrl);
    }
  }

  // ✅ メイン画像のプレビュー表示
  displayMainImage(event) {
    const file = event.target.files[0];
    if (!file) return;

    if (!this.isValidImage(file)) {
      alert("画像は5MB以下のファイルを選択してください");
      event.target.value = "";
      return;
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      this.setMainImage(e.target.result);
    };
    reader.readAsDataURL(file);
  }

  // ✅ メイン画像のセット
  setMainImage(imageUrl) {
    this.mainImagePreviewTarget.innerHTML = `
      <div class="position-relative w-100 h-100">
        <img src="${imageUrl}" class="img-thumbnail w-100 h-100 object-fit-cover clickable"
          data-action="click->image-preview#triggerMainImageSelection">
        <button type="button" class="btn btn-danger btn-sm position-absolute top-0 end-0"
          data-action="click->image-preview#removeMainImage">×</button>
      </div>
    `;
  }

  // ✅ メイン画像の削除
  removeMainImage() {
    this.mainImagePreviewTarget.innerHTML = `<div class="clickable text-center text-muted w-100 h-100 d-flex align-items-center justify-content-center border"
      data-action="click->image-preview#triggerMainImageSelection">No Image</div>`;
    this.mainImageInputTarget.value = "";
  }

  // ✅ メイン画像のクリックで `input[type="file"]` を開く
  triggerMainImageSelection() {
    this.mainImageInputTarget.click();
  }

  // ✅ 画像のバリデーション（5MB以下）
  isValidImage(file) {
    return file.size <= 5 * 1024 * 1024;
  }
}
