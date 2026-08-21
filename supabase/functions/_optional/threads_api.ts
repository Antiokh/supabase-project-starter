import { optionalEnv, requireEnv } from '../_shared/env.ts';
import { meta_get, meta_post } from './meta_graph_api.ts';

export type ThreadsPublishResult = {
    creation_id: string;
    publish_id: string;
};

export function get_threads_user_id(): string {
    return optionalEnv('THREADS_USER_ID') || requireEnv('THREADS_USER_ID');
}

export async function threads_get_me(fields = 'id,username,name'): Promise<unknown> {
    return meta_get(get_threads_user_id(), { fields });
}

export async function threads_create_text_post(params: {
    text: string;
    reply_control?: 'everyone' | 'accounts_you_follow' | 'mentioned_only';
    link_attachment?: string;
}) {
    const body: Record<string, unknown> = {
        media_type: 'TEXT',
        text: params.text,
    };
    if (params.reply_control) body.reply_control = params.reply_control;
    if (params.link_attachment) body.link_attachment = params.link_attachment;

    const result = await meta_post<{ id: string }>(`${get_threads_user_id()}/threads`, body);
    if (!result.id) throw new Error('Threads creation did not return id');
    return result.id;
}

export async function threads_publish_creation(creation_id: string) {
    const result = await meta_post<{ id: string }>(`${get_threads_user_id()}/threads_publish`, {
        creation_id,
    });
    if (!result.id) throw new Error('Threads publish did not return id');
    return result.id;
}

export async function threads_publish_text(params: {
    text: string;
    reply_control?: 'everyone' | 'accounts_you_follow' | 'mentioned_only';
    link_attachment?: string;
}): Promise<ThreadsPublishResult> {
    const creation_id = await threads_create_text_post(params);
    const publish_id = await threads_publish_creation(creation_id);
    return { creation_id, publish_id };
}
