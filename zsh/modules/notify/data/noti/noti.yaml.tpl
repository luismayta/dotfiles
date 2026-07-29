# yaml-language-server: $schema=https://raw.githubusercontent.com/variadico/noti/refs/heads/main/docs/noti.schema.json
---
# noti configuration
# See https://github.com/variadico/noti for documentation.

$schema: https://raw.githubusercontent.com/variadico/noti/refs/heads/main/docs/noti.schema.json

telegram:
  token: {{ getenv "ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN" }}
  chatId: {{ getenv "ZSH_NOTIFY_NOTI_TELEGRAM_CHATID"}}

banner:
  icon: {{ getenv "ZSH_NOTIFY_ASSETS_PATH" }}/success.jpg

