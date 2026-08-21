// Compatibility shim.
// The canonical optional helper lives in ../_optional/telegram_bot_api.ts.
export {
    delete_message as deleteMessage,
    download_telegram_file as downloadTelegramFile,
    get_telegram_debug_chat_id as getTelegramDebugChatId,
    get_webhook_info as getWebhookInfo,
    send_document as sendDocument,
    send_message as sendMessage,
    send_debug_message as sendTelegramHtmlMessage,
    set_webhook as setWebhook,
} from '../_optional/telegram_bot_api.ts';
