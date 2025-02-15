// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   static targets = ["preview"];

//   update(event) {
//     console.log("✅ アバター画像が選択されました"); // デバッグ用ログ

//     if (!event.target.files.length) {
//       console.warn("⚠ ファイルが選択されていません");
//       return;
//     }

//     const file = event.target.files[0];

//     if (!file.type.startsWith("image/")) {
//       console.error("❌ 選択されたファイルは画像ではありません");
//       return;
//     }

//     const reader = new FileReader();
//     reader.onload = (e) => {
//       this.previewTarget.src = e.target.result;
//     };
//     reader.readAsDataURL(file);
//   }
// }
