import { optionalEnv, requireEnv } from '../_shared/env.ts';

export type MetaGraphResponse<T = unknown> = T & {
    id?: string;
    error?: {
        message?: string;
        type?: string;
        code?: number;
        error_subcode?: number;
        fbtrace_id?: string;
    };
};

function get_meta_access_token(): string {
    return requireEnv('META_GRAPH_ACCESS_TOKEN');
}

function get_graph_base_url(): string {
    return optionalEnv('META_GRAPH_BASE_URL', { defaultValue: 'https://graph.facebook.com/v24.0' })!;
}

function build_graph_url(path: string, query?: Record<string, string | number | boolean | undefined>): string {
    const url = new URL(`${get_graph_base_url().replace(/\/$/, '')}/${path.replace(/^\//, '')}`);
    url.searchParams.set('access_token', get_meta_access_token());

    if (query) {
        for (const [key, value] of Object.entries(query)) {
            if (value == null) continue;
            url.searchParams.set(key, String(value));
        }
    }

    return url.toString();
}

async function meta_call<T = unknown>(
    method: 'GET' | 'POST',
    path: string,
    body?: Record<string, unknown>,
    query?: Record<string, string | number | boolean | undefined>
): Promise<MetaGraphResponse<T>> {
    const response = await fetch(build_graph_url(path, query), {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: body ? JSON.stringify(body) : undefined,
    });

    const json = (await response.json()) as MetaGraphResponse<T>;

    if (!response.ok || json?.error) {
        const message = json?.error?.message || `Meta Graph API error (${response.status})`;
        throw new Error(message);
    }

    return json;
}

export async function meta_get<T = unknown>(
    path: string,
    query?: Record<string, string | number | boolean | undefined>
): Promise<MetaGraphResponse<T>> {
    return meta_call<T>('GET', path, undefined, query);
}

export async function meta_post<T = unknown>(
    path: string,
    body?: Record<string, unknown>,
    query?: Record<string, string | number | boolean | undefined>
): Promise<MetaGraphResponse<T>> {
    return meta_call<T>('POST', path, body, query);
}
