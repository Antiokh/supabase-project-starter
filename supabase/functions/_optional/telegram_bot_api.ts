import { optionalEnv, requireEnv } from '../_shared/env.ts';

export type TelegramChatId = number | string;

export type TelegramReplyMarkup = {
    inline_keyboard?: Array<Array<{ text: string; callback_data?: string; url?: string; web_app?: { url: string } }>>;
    keyboard?: Array<Array<{ text: string }>>;
    resize_keyboard?: boolean;
    one_time_keyboard?: boolean;
    remove_keyboard?: boolean;
    force_reply?: boolean;
};

function get_bot_token(): string {
    return requireEnv('TELEGRAM_BOT_TOKEN');
}

function tg_api_base(): string {
    return `https://api.telegram.org/bot${get_bot_token()}`;
}

function tg_file_base(): string {
    return `https://api.telegram.org/file/bot${get_bot_token()}`;
}

async function tg_call<T = unknown>(method: string, payload?: Record<string, unknown>): Promise<T> {
    const response = await fetch(`${tg_api_base()}/${method}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: payload ? JSON.stringify(payload) : undefined,
    });

    const json = await response.json();

    if (!json.ok) {
        throw new Error(`Telegram API error (${method}): ${json.description}`);
    }

    return json.result as T;
}

function escape_html(value: string): string {
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}

function safe_stringify(payload: unknown): string {
    try {
        return JSON.stringify(
            payload,
            (_, value) => (typeof value === 'bigint' ? value.toString() : value),
            2
        );
    } catch {
        return String(payload);
    }
}

export function get_telegram_debug_chat_id(): string | undefined {
    return optionalEnv('TELEGRAM_DEBUG_CHAT_ID') || optionalEnv('TELEGRAM_DEV_CHAT_ID');
}

export async function send_message(params: {
    chat_id: TelegramChatId;
    text: string;
    parse_mode?: 'HTML' | 'MarkdownV2';
    reply_markup?: TelegramReplyMarkup;
    disable_preview?: boolean;
}) {
    return tg_call('sendMessage', {
        chat_id: params.chat_id,
        text: params.text,
        parse_mode: params.parse_mode,
        reply_markup: params.reply_markup,
        disable_web_page_preview: params.disable_preview,
    });
}

export async function send_document(params: {
    chat_id: TelegramChatId;
    url: string;
    caption?: string;
    parse_mode?: 'HTML' | 'MarkdownV2';
    reply_markup?: TelegramReplyMarkup;
}) {
    return tg_call('sendDocument', {
        chat_id: params.chat_id,
        document: params.url,
        caption: params.caption,
        parse_mode: params.parse_mode,
        reply_markup: params.reply_markup,
    });
}

export async function delete_message(params: { chat_id: TelegramChatId; message_id: number }) {
    return tg_call('deleteMessage', {
        chat_id: params.chat_id,
        message_id: params.message_id,
    });
}

export async function get_webhook_info() {
    return tg_call('getWebhookInfo');
}

export async function set_webhook(params: {
    url: string;
    secret_token?: string;
    allowed_updates?: string[];
}) {
    return tg_call('setWebhook', {
        url: params.url,
        secret_token: params.secret_token,
        allowed_updates: params.allowed_updates,
    });
}

export async function send_debug_message(params: {
    source: string;
    message: string;
    payload?: unknown;
    chat_id?: string;
}) {
    const chat_id = params.chat_id || get_telegram_debug_chat_id();
    if (!chat_id) return { ok: false, skipped: true };

    const payload_text = params.payload == null ? '' : safe_stringify(params.payload);
    const text =
        `<b>${escape_html(params.source)}</b>\n` +
        `${escape_html(params.message)}\n` +
        (payload_text ? `<pre><code>${escape_html(payload_text).slice(0, 3500)}</code></pre>` : '');

    await send_message({
        chat_id,
        text,
        parse_mode: 'HTML',
    });

    return { ok: true };
}

export async function download_telegram_file(file_id: string): Promise<{
    buffer: Uint8Array;
    filename: string;
    content_type: string;
}> {
    const file_info = await tg_call<{ file_path?: string }>('getFile', { file_id });

    if (!file_info.file_path) {
        throw new Error('Telegram file_path is missing');
    }

    const response = await fetch(`${tg_file_base()}/${file_info.file_path}`);
    if (!response.ok) {
        throw new Error('Failed to download telegram file');
    }

    const buffer = new Uint8Array(await response.arrayBuffer());
    const content_type = response.headers.get('content-type') ?? 'application/octet-stream';
    const filename = file_info.file_path.split('/').pop() ?? 'file';

    return { buffer, filename, content_type };
}

