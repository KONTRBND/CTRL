import { defineConfig } from "vitepress";
import mdPluginIconify from "mdit-plugin-iconify";
import { createIconRenderer, mditPluginIconifyPattern, parseAttrs } from "mdit-plugin-iconify";

import { icons as lucideIcons } from "@iconify-json/lucide";
import { icons as simpleIcons } from "@iconify-json/simple-icons";
import { icons as ctrlIcons } from "./ctrl-icons";


const iconRenderer = createIconRenderer({
  collections: {
    lucide: lucideIcons,
    logo: simpleIcons,
    ctrl: ctrlIcons,
  },
  defaultCollection: lucideIcons,
});


export default defineConfig({
  title: "CTRL",

  rewrites: {
    "en/:rest*": ":rest*",
  },

  srcExclude: [
    "**/README.md",
    "**/TODO.md",
  ],

  base: "/CTRL/",
  lastUpdated: true,
  cleanUrls: true,
  metaChunk: true,
  ignoreDeadLinks: "localhostLinks",

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/CTRL/favicon.svg' }],
    ['meta', { name: 'theme-color', content: '#00C8D5' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:locale', content: 'en' }],
    ['meta', { property: 'og:title', content: 'KONTRBND - CTRL' }],
    ['meta', { property: 'og:site_name', content: 'KONTRBND - CTRL' }],
    ['meta', { property: 'og:image', content: 'https://KONTRBND.github.io/CTRL/og-image.png' }],
    ['meta', { property: 'og:image:type', content: 'image/png' }],
    ['meta', { property: 'og:url', content: 'https://KONTRBND.github.io/CTRL' }],
  ],

  sitemap: {
    hostname: "https://KONTRBND.github.io/CTRL",
  },

  themeConfig: {
    logo: "/favicon.svg",
    socialLinks: [
      { icon: 'github', link: 'https://github.com/KONTRBND/CTRL' },
    ],
    search: {
      provider: "local",
    },
  },
  markdown: {
    config(md) {
      md.use(mdPluginIconify, iconRenderer);
    },
    image: {
      lazyLoading: true,
    },
  },
  transformPageData(pageData) {
    if (pageData.frontmatter.layout === 'home' && Array.isArray(pageData.frontmatter.features)) {
      for (const feature of pageData.frontmatter.features) {
        if ('icon' in feature && typeof feature.icon === "string") {
          feature.icon = feature.icon.replaceAll(mditPluginIconifyPattern, (_match: string, maybeCollection: string, name: string, attrStr: string) => {
            return iconRenderer(maybeCollection, name, parseAttrs(attrStr));
          });
        }
      }
    }
  },
});
