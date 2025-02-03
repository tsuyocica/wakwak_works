import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["statusSelect"];

  connect() {
    console.log("JobApplicationsController connected!");
  }

  updateStatus(event) {
    const selectElement = event.target;
    const applicationId = selectElement.dataset.applicationId;
    const jobPostId = this.element.dataset.jobPostId;
    const newStatus = selectElement.value;
    const chatRoomCell = document.querySelector(
      selectElement.dataset.chatTarget
    );
    const statusIcon = document.querySelector(selectElement.dataset.statusIcon);

    if (!jobPostId || jobPostId === "0") {
      console.error("job_post_id が無効です:", jobPostId);
      return;
    }

    fetch(
      `/job_posts/${jobPostId}/job_applications/${applicationId}/update_status`,
      {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ status: newStatus }),
      }
    )
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          console.log("応募の状態更新成功:", data.status);

          // ✅ Bootstrapアイコンを利用して状態を更新
          if (statusIcon) {
            if (newStatus === "approved") {
              statusIcon.innerHTML = `<i class="bi bi-check-circle-fill text-success"></i>`; // 承認アイコン
            } else if (newStatus === "rejected") {
              statusIcon.innerHTML = `<i class="bi bi-x-circle-fill text-danger"></i>`; // 却下アイコン
            } else {
              statusIcon.innerHTML = "";
            }
          }

          // ✅ チャットルーム表示を更新
          if (chatRoomCell) {
            chatRoomCell.innerHTML =
              newStatus === "approved"
                ? `<a href="#" class="btn btn-primary btn-sm">チャットを開く</a>`
                : `<span class="text-muted">-</span>`;
          }
        } else {
          alert("更新に失敗しました");
        }
      })
      .catch((error) => {
        console.error("エラー:", error);
      });
  }
}
