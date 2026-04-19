#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const SITE_CONFIG_PATH = path.join(ROOT, 'public', 'generated', 'site-config.json');
const MANIFEST_PATH = path.join(ROOT, 'public', 'manifest.json');

function main() {
  let config = { site_name: 'EDU Publish', site_short_name: 'EDU Publish', site_description: '高校通知聚合站' };
  if (fs.existsSync(SITE_CONFIG_PATH)) {
    config = JSON.parse(fs.readFileSync(SITE_CONFIG_PATH, 'utf-8'));
  }

  const themeColor = config._computed?.theme_color_hex || '#2563eb';

  const manifest = {
    name: config.site_name,
    short_name: config.site_short_name,
    id: '/',
    description: config.site_description,
    start_url: '/',
    scope: '/',
    display: 'standalone',
    display_override: ['standalone', 'minimal-ui'],
    theme_color: themeColor,
    background_color: '#fafafa',
    orientation: 'any',
    icons: [
      { src: '/icon-192.png', sizes: '192x192', type: 'image/png', purpose: 'any' },
      { src: '/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any' },
    ],
  };

  fs.writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2));
  console.log(`[generate-manifest] Wrote ${MANIFEST_PATH}`);
}

main();
