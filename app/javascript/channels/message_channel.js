import consumer from "channels/consumer";

if (location.pathname.match(/\/chats\/\d+/)) {
  const chatId = location.pathname.match(/\d+$/)[0];

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

        const messages = document.getElementById("messages");
        messages.insertAdjacentHTML("beforeend", data.message_html);
      },
    }
  );
}
