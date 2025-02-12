import consumer from "channels/consumer";

if (location.pathname.match(/\/chats\/\d+/)) {
  const chatId = location.pathname.match(/\d+$/)[0];

  // ✅ チャットごとにActionCableのサブスクリプションを作成
  consumer.subscriptions.create(
    { channel: "MessageChannel", chat_id: chatId },
    {
      connected() {
        console.log(`✅ MessageChannel: チャット${chatId}に接続しました`);
      },

      disconnected() {
        console.log(`❌ MessageChannel: チャット${chatId}から切断されました`);
      },

      received(data) {
        console.log("📩 受信データ:", data);

        const messagesContainer = document.getElementById("messages");
        if (messagesContainer) {
          messagesContainer.insertAdjacentHTML("beforeend", data.message_html);
          scrollToBottom();
        }
      },
    }
  );

  // ✅ フォーム送信後にリセット（入力クリア）
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

  // ✅ 新しいメッセージが追加されたら、自動スクロール
  function scrollToBottom() {
    const messagesContainer = document.getElementById("messages");
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  }

  // ✅ 初回ロード時にスクロールを適用
  document.addEventListener("turbo:load", scrollToBottom);
}
