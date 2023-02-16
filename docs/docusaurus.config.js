// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
    title: 'flutter_naver_map',
    tagline: '',
    favicon: 'img/favicon.ico',

    url: 'https://note11.dev/',
    baseUrl: '/flutter_naver_map/',

    organizationName: 'note11g',
    projectName: 'flutter_naver_map',

    onBrokenLinks: 'throw',
    onBrokenMarkdownLinks: 'warn',

    i18n: {
        defaultLocale: 'ko',
        locales: ['ko'],
    },

    presets: [
        [
            'classic',
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    routeBasePath: '/',
                    sidebarPath: require.resolve('./sidebars.js'),
                },
                blog: false,
                theme: {
                    customCss: require.resolve('./src/css/custom.css'),
                },
            }),
        ],
    ],

    themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            image: 'img/og_image.jpg',
            docs: {
                sidebar: {
                    hideable: true,
                },
            },
            navbar: {
                title: 'flutter_naver_map',
                logo: {
                    alt: 'flutter_naver_map Logo',
                    src: 'img/logo.svg',
                },
                items: [
                    {
                        type: 'doc',
                        docId: 'start/intro',
                        position: 'left',
                        label: '시작하기',
                    },
                    {
                        type: 'doc',
                        docId: 'element/widget',
                        position: 'left',
                        label: '핵심 구성요소',
                    },
                    {
                        href: 'https://pub.dev/packages/flutter_naver_map',
                        label: 'pub.dev',
                        position: 'right'
                    },
                    {
                        href: 'https://github.com/note11g/flutter_naver_map',
                        label: 'github',
                        position: 'right',
                    },
                ],
            },
            footer: {
                style: 'light',
                copyright: `Copyright © ${new Date().getFullYear()} <a href="https://github.com/note11g">note11g</a>. Built with Docusaurus.`,
            },
            prism: {
                theme: lightCodeTheme,
                darkTheme: darkCodeTheme,
                additionalLanguages: ['dart'],
            },
        }),
};

module.exports = config;
