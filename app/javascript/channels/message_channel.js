import consumer from "./consumer";
console.log("✅ message_channel.js が読み込まれました！");

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
        console.log("📩 受信データ:", data);

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
              "border-info-subtle"
            ); // ✅ 送信者: ボーダー付き
            messageTimestamp.classList.add("align-self-start", "ms-auto"); // ✅ 左側に配置
            messageContainer.style.marginLeft = "auto";
          } else {
            console.log("✅ 受信者:", data);
            messageContainer.classList.add("text-start", "bg-light"); // ✅ 受信者: 背景のみ（ボーダーなし）
            messageTimestamp.classList.add("align-self-end", "me-auto"); // ✅ 右側に配置
            messageContainer.style.marginRight = "auto";
          }

          // ✅ メッセージ本文（空でない場合のみ追加）
          if (data.content && data.content.trim() !== "") {
            const messageContent = document.createElement("p");
            messageContent.classList.add("mb-1");
            messageContent.textContent = data.content;
            messageContainer.appendChild(messageContent);
          }

          // ✅ 画像の表示
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

          // ✅ ファイルの表示
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
                }`; // ファイル名を取得

                fileWrapper.appendChild(fileLink);
              } else {
                console.warn("⚠️ 無効なファイルデータ:", fileObj);
              }
            });

            messageContainer.appendChild(fileWrapper);
          }

          // ✅ 日時をセット
          messageTimestamp.textContent = data.timestamp;

          // ✅ 要素を追加
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
          // ✅ ファイル入力もクリア
          const fileInputs = form.querySelectorAll('input[type="file"]');
          fileInputs.forEach((input) => (input.value = ""));
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
