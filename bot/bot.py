import os
from dotenv import load_dotenv
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes

load_dotenv("/opt/routing-vps-bot/bot/.env")
BOT_TOKEN = os.getenv("BOT_TOKEN")
OWNER_ID = int(os.getenv("OWNER_ID"))

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id != OWNER_ID:
        await update.message.reply_text("⛔ Akses ditolak.")
        return
    await update.message.reply_text("✅ Bot routing aktif. Gunakan /status untuk melihat status.")

async def status(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id != OWNER_ID:
        await update.message.reply_text("⛔ Akses ditolak.")
        return
    config_path = "/opt/routing-vps-bot/config.ini"
    if not os.path.exists(config_path):
        await update.message.reply_text("❌ Belum ada konfigurasi routing.")
        return
    with open(config_path) as f:
        await update.message.reply_text(f"📄 Konfigurasi:\n\n`{f.read()}`", parse_mode="Markdown")

if __name__ == "__main__":
    app = ApplicationBuilder().token(BOT_TOKEN).build()
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("status", status))
    print("🚀 Bot Telegram Routing aktif...")
    app.run_polling()
