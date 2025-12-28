import { DefaultTheme, defineConfig } from "vitepress";

export default defineConfig({
  lang: "en-US",
  description: "CTRL is a compact, open-source macropad evolving to a capable input device",
  themeConfig: {
    nav: nav(),
    sidebar: sidebar(),
  },
});

function nav(): DefaultTheme.NavItem[] {
  return [
    { text: "Home", link: "/" },
    { text: "Hardware", link: "/hardware/introduction" },
    { text: "Firmware", link: "/firmware/introduction" },
  ];
}

function sidebar(): DefaultTheme.Sidebar {
  return {
    "/hardware/": [
      {
        text: "Introduction",
        link: "/hardware/introduction",
      },
    ],
    "/firmware/": [
      {
        text: "Introduction",
        link: "/firmware/introduction",
      },
    ],
  };
}
