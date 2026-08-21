import { Octokit } from '@octokit';

import { createDbg } from '../_shared/dbg.ts';
import { optionalEnv, requireEnv } from '../_shared/env.ts';

const dbg = createDbg(false);

function getOctokit() {
    return new Octokit({
        auth: requireEnv('GITHUB_TOKEN'),
    });
}

function buildGroupedContent(schema: string, functionName: string, mode: 'legacy' | 'grouped', blocks: string[]) {
    const header =
        `-- AUTO-GENERATED. DO NOT EDIT.\n` +
        `-- Schema:   ${schema}\n` +
        `-- Function: ${functionName}\n` +
        `-- Mode:     ${mode}\n` +
        `-- Updated:  ${new Date().toISOString()}\n\n`;

    return `${header}${blocks.join('\n\n')}\n`;
}

function encodeUtf8Base64(input: string) {
    return btoa(unescape(encodeURIComponent(input)));
}

Deno.serve(async req => {
    try {
        const body = await req.json();
        await dbg('github-send', 'function invoked', body);

        const genericPath = body.path;
        const genericContent = body.content;
        const genericMessage = body.message;
        const schema = body.schema;
        const functionName = body.function_name;
        const overloads = body.overloads;

        const legacyArgs = body.args;
        const legacyReturnType = body.return_type;
        const legacyLanguage = body.language;
        const legacySourceCode = body.source_code;

        const owner = requireEnv('GITHUB_OWNER');
        const repo = requireEnv('GITHUB_REPO');
        const branch = optionalEnv('GITHUB_BRANCH') || 'main';
        const octokit = getOctokit();

        let path: string;
        let content: string;
        let commitMessage: string;
        let responseMode: 'legacy' | 'grouped' | 'file';
        let overloadCount = 0;

        if (genericPath && typeof genericContent === 'string') {
            path = String(genericPath);
            content = genericContent;
            commitMessage = genericMessage || `file update: ${path}`;
            responseMode = 'file';
        } else {
            if (!schema || !functionName) {
                return Response.json({ error: 'invalid payload' }, { status: 400 });
            }

            let mode: 'legacy' | 'grouped';
            let sqlBlocks: string[] = [];

            if (Array.isArray(overloads)) {
                mode = 'grouped';
                sqlBlocks = overloads.map((overload: Record<string, string>) => {
                    const header =
                        `-- overload\n` +
                        `-- language: ${overload.language ?? ''}\n` +
                        `-- args: ${overload.args ?? ''}\n` +
                        `-- returns: ${overload.return_type ?? ''}\n\n`;

                    return header + String(overload.source_code ?? '').trim();
                });
            } else if (legacySourceCode) {
                mode = 'legacy';
                const header =
                    `-- overload\n` +
                    `-- language: ${legacyLanguage ?? ''}\n` +
                    `-- args: ${legacyArgs ?? ''}\n` +
                    `-- returns: ${legacyReturnType ?? ''}\n\n`;

                sqlBlocks = [header + String(legacySourceCode).trim()];
            } else {
                return Response.json({ error: 'no overloads or source_code provided' }, { status: 400 });
            }

            path = `db/${schema}/${functionName}.sql`;
            content = buildGroupedContent(schema, functionName, mode, sqlBlocks);
            commitMessage =
                mode === 'grouped'
                    ? `sql function update: ${schema}.${functionName} (${sqlBlocks.length} overload${sqlBlocks.length === 1 ? '' : 's'})`
                    : `sql function update: ${schema}.${functionName} (${legacyArgs ?? ''}) returns ${legacyReturnType ?? ''}`;
            responseMode = mode;
            overloadCount = sqlBlocks.length;
        }

        let sha: string | undefined;

        try {
            const result = await octokit.rest.repos.getContent({
                owner,
                repo,
                path,
                ref: branch,
            });

            if (!Array.isArray(result.data)) {
                sha = result.data.sha;
            }
        } catch {
            // File does not exist yet.
        }

        const encodedContent = encodeUtf8Base64(content);

        const result = await octokit.rest.repos.createOrUpdateFileContents({
            owner,
            repo,
            path,
            message: commitMessage,
            content: encodedContent,
            sha,
            branch,
        });

        await dbg('github-send', 'file committed', {
            path,
            commit: result.data.commit.sha,
            mode: responseMode,
            overloads: overloadCount,
        });

        return Response.json({
            ok: true,
            mode: responseMode,
            path,
            overloads: overloadCount,
            commit: result.data.commit.sha,
            message: commitMessage,
        });
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        return Response.json({ error: message }, { status: 500 });
    }
});
