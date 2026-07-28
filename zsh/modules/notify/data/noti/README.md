# noti data

Configuration templates for noti.

## Setup

1. Get a Telegram bot token from @BotFather
2. Get your chat ID: message the bot, then visit `https://api.telegram.org/bot<TOKEN>/getUpdates`
3. Set env vars in `.zshrc.local`:

```bash
export ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN="your-token"
export ZSH_NOTIFY_NOTI_TELEGRAM_CHATID="your-chatid"
```

4. Restart zsh. Config generates automatically on first load.
