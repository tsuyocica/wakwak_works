import consumer from "channels/consumer";

// ✅ 現在のユーザーIDを `body` の `data-user-id` から取得
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
        const messagesContainer = document.getElementById("messages");
        if (messagesContainer) {
          // ✅ メッセージ全体のラッパー
          const messageWrapper = document.createElement("div");
          messageWrapper.classList.add("d-flex", "flex-column", "mt-2");

          // ✅ 日時（枠の外側）
          const messageTimestamp = document.createElement("span");
          messageTimestamp.classList.add("text-muted", "small", "mb-1");

          // ✅ メッセージ本体（枠）
          const messageContainer = document.createElement("div");
          messageContainer.classList.add("p-2", "rounded-2", "text-dark");
          messageContainer.style.maxWidth = "60%"; // ✅ 最大幅を60%に制限
          messageContainer.style.width = "auto"; // ✅ 可変サイズ

          // ✅ 送信者・受信者の判定
          if (data.sender_id == currentUserId) {
            console.log("✅ 送信者:", data);
            messageContainer.classList.add(
              "text-end",
              "ms-auto",
              "bg-white",
              "border",
              "border-secondary"
            ); // ✅ 送信者: ボーダー付き
            messageTimestamp.classList.add("align-self-start", "ms-auto"); // ✅ 左側に配置
            messageContainer.style.marginLeft = "auto";
          } else {
            console.log("✅ 受信者:", data);
            messageContainer.classList.add("text-start", "bg-light"); // ✅ 受信者: 背景のみ（ボーダーなし）
            messageTimestamp.classList.add("align-self-end", "me-auto"); // ✅ 右側に配置
            messageContainer.style.marginRight = "auto";
          }

          // ✅ メッセージ本文
          const messageContent = document.createElement("p");
          messageContent.classList.add("mb-1");
          messageContent.textContent = data.content;

          // ✅ 日時とメッセージを追加
          messageTimestamp.textContent = data.timestamp;
          messageContainer.appendChild(messageContent);
          messageWrapper.appendChild(messageTimestamp);
          messageWrapper.appendChild(messageContainer);
          messagesContainer.appendChild(messageWrapper);

          // ✅ スクロールを最下部に移動
          scrollToBottom();
        }
      },
    }
  );

  // ✅ フォーム送信後に入力欄をクリア
  document.addEventListener("turbo:load", () => {
    const form = document.querySelector("#message-form form");
    if (form) {
      form.addEventListener("submit", (event) => {
        setTimeout(() => {
          form.reset(); // フォームをクリア
        }, 100);
      });
    }
  });

  // ✅ スクロール処理
  function scrollToBottom() {
    const messagesContainer = document.getElementById("messages");
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  }

  // ✅ 初回ロード時にスクロールを適用
  document.addEventListener("turbo:load", scrollToBottom);
}
