import consumer from "./consumer";
console.log("✅ message_channel.js が読み込まれました！");

// ✅ ActionCable の接続を初期化する関数
function setupMessageChannel() {
  console.log("✅ setupMessageChannel が実行されました");

  // ✅ 既存の subscription を削除（不要なチャンネル接続を防ぐ）
  consumer.subscriptions.subscriptions.forEach((subscription) => {
    consumer.subscriptions.remove(subscription);
  });

  // ✅ 現在のユーザーIDを取得
  const currentUserId = document.body.dataset.userId;

  if (location.pathname.match(/\/chats\/\d+/)) {
    const chatId = location.pathname.match(/\d+$/)[0];

    consumer.subscriptions.create(
      { channel: "MessageChannel", chat_id: chatId },
      {
        connected() {
          console.log(`✅ MessageChannel: チャット${chatId}に接続しました`);
          console.log(`✅ 現在のユーザーID: ${currentUserId}`);
        },

        disconnected() {
          console.log(`❌ MessageChannel: チャット${chatId}から切断されました`);
        },

        received(data) {
          console.log("📩 受信データ:", data);

          const messagesContainer = document.getElementById("messages");
          if (messagesContainer) {
            const messageWrapper = document.createElement("div");
            messageWrapper.classList.add("d-flex", "flex-column", "mt-2");

            const messageTimestamp = document.createElement("span");
            messageTimestamp.classList.add("text-muted", "small", "mb-1");

            const messageContainer = document.createElement("div");
            messageContainer.classList.add("p-2", "rounded-2", "text-dark");
            messageContainer.style.maxWidth = "60%";
            messageContainer.style.width = "auto";

            if (data.sender_id == currentUserId) {
              console.log("✅ 送信者:", data);
              messageContainer.classList.add(
                "text-end",
                "ms-auto",
                "bg-white",
                "border",
                "border-info-subtle"
              );
              messageTimestamp.classList.add("align-self-start", "ms-auto");
              messageContainer.style.marginLeft = "auto";
            } else {
              console.log("✅ 受信者:", data);
              messageContainer.classList.add("text-start", "bg-light");
              messageTimestamp.classList.add("align-self-end", "me-auto");
              messageContainer.style.marginRight = "auto";
            }

            if (data.content && data.content.trim() !== "") {
              const messageContent = document.createElement("p");
              messageContent.classList.add("mb-1");
              messageContent.textContent = data.content;
              messageContainer.appendChild(messageContent);
            }

            if (data.images && data.images.length > 0) {
              console.log("📷 画像を追加:", data.images);
              const imageWrapper = document.createElement("div");
              imageWrapper.classList.add("mt-2");

              data.images.forEach((imageUrl) => {
                const imageLink = document.createElement("a");
                imageLink.href = imageUrl;
                imageLink.target = "_blank";

                const imageElement = document.createElement("img");
                imageElement.src = imageUrl;
                imageElement.classList.add("img-fluid", "rounded");
                imageElement.style.maxWidth = "100px";
                imageElement.style.maxHeight = "100px";

                imageLink.appendChild(imageElement);
                imageWrapper.appendChild(imageLink);
              });

              messageContainer.appendChild(imageWrapper);
            }

            if (data.files && data.files.length > 0) {
              console.log("📎 ファイルを追加:", data.files);
              const fileWrapper = document.createElement("div");
              fileWrapper.classList.add("mt-2");

              data.files.forEach((fileObj) => {
                if (fileObj && typeof fileObj.url === "string") {
                  const fileLink = document.createElement("a");
                  fileLink.href = fileObj.url;
                  fileLink.target = "_blank";
                  fileLink.classList.add("d-block", "text-truncate");
                  fileLink.style.maxWidth = "100%";
                  fileLink.textContent = `📎 ${
                    fileObj.name || fileObj.url.split("/").pop()
                  }`;

                  fileWrapper.appendChild(fileLink);
                } else {
                  console.warn("⚠️ 無効なファイルデータ:", fileObj);
                }
              });

              messageContainer.appendChild(fileWrapper);
            }

            messageTimestamp.textContent = data.timestamp;

            messageWrapper.appendChild(messageTimestamp);
            messageWrapper.appendChild(messageContainer);
            messagesContainer.appendChild(messageWrapper);

            scrollToBottom();
          }
        },
      }
    );

    // ✅ フォーム送信後に入力欄をクリア
    const form = document.querySelector("#message-form form");
    if (form) {
      form.addEventListener("submit", (event) => {
        setTimeout(() => {
          form.reset();
          const fileInputs = form.querySelectorAll('input[type="file"]');
          fileInputs.forEach((input) => (input.value = ""));
        }, 100);
      });
    }
  }
}

// ✅ turbo:load でページ遷移時に ActionCable を再接続
document.addEventListener("turbo:load", setupMessageChannel);

// ✅ スクロール処理
function scrollToBottom() {
  const messagesContainer = document.getElementById("messages");
  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }
}

// ✅ 初回ロード時にスクロールを適用
document.addEventListener("turbo:load", scrollToBottom);
