import { optionalEnv, requireEnv } from '../_shared/env.ts';
import { meta_get, meta_post } from './meta_graph_api.ts';

export type InstagramPublishResult = {
    creation_id: string;
    publish_id: string;
};

export function get_instagram_business_account_id(): string {
    return (
        optionalEnv('INSTAGRAM_BUSINESS_ACCOUNT_ID') ||
        optionalEnv('INSTAGRAM_USER_ID') ||
        requireEnv('INSTAGRAM_BUSINESS_ACCOUNT_ID')
    );
}

export async function instagram_get_me(fields = 'id,username'): Promise<unknown> {
    return meta_get(get_instagram_business_account_id(), { fields });
}

export async function instagram_create_media(params: {
    image_url?: string;
    video_url?: string;
    caption?: string;
    media_type?: 'IMAGE' | 'VIDEO' | 'REELS';
    is_carousel_item?: boolean;
}) {
    const body: Record<string, unknown> = {};
    if (params.image_url) body.image_url = params.image_url;
    if (params.video_url) body.video_url = params.video_url;
    if (params.caption) body.caption = params.caption;
    if (params.media_type) body.media_type = params.media_type;
    if (params.is_carousel_item != null) body.is_carousel_item = params.is_carousel_item;

    const result = await meta_post<{ id: string }>(`${get_instagram_business_account_id()}/media`, body);
    if (!result.id) throw new Error('Instagram media creation did not return id');
    return result.id;
}

export async function instagram_publish_media(creation_id: string) {
    const result = await meta_post<{ id: string }>(`${get_instagram_business_account_id()}/media_publish`, {
        creation_id,
    });
    if (!result.id) throw new Error('Instagram media publish did not return id');
    return result.id;
}

export async function instagram_publish_photo(params: {
    image_url: string;
    caption?: string;
}): Promise<InstagramPublishResult> {
    const creation_id = await instagram_create_media({
        image_url: params.image_url,
        caption: params.caption,
        media_type: 'IMAGE',
    });
    const publish_id = await instagram_publish_media(creation_id);
    return { creation_id, publish_id };
}
