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
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        if (data.success) {
          console.log("✅ 応募の状態更新成功:", data.status);

          // **アイコンの更新**
          if (statusIcon) {
            statusIcon.innerHTML =
              data.status === "approved"
                ? `<i class="bi bi-check-circle-fill text-success"></i>`
                : data.status === "rejected"
                ? `<i class="bi bi-x-circle-fill text-danger"></i>`
                : "";
          }

          // **チャットルームのボタンを動的に変更**
          if (chatRoomCell) {
            if (data.status === "approved") {
              chatRoomCell.innerHTML = `
                <form action="/chats" method="POST">
                  <input type="hidden" name="authenticity_token" value="${
                    document.querySelector('meta[name="csrf-token"]').content
                  }">
                  <input type="hidden" name="job_post_id" value="${jobPostId}">
                  <input type="hidden" name="worker_id" value="${
                    data.worker_id
                  }">
                  <button type="submit" class="btn btn-primary btn-sm">チャットを作成</button>
                </form>
              `;
            } else {
              chatRoomCell.innerHTML = `<span class="text-muted">-</span>`;
            }
          }
        } else {
          alert("⚠️ 更新に失敗しました");
        }
      })
      .catch((error) => {
        console.error("❌ エラー:", error);
      });
  }
}
