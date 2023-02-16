// @ts-check

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
    docs: [
        {
            type: "category",
            label: "시작하기",
            link: {
                id: "start/intro",
                type: "doc",
            },
            items: ['start/initial_setting', 'start/start_use'],
        },
        {
            type: "category",
            label: "핵심 구성요소",
            // link: {
            //     type: "generated-index"
            // },
            items: ['element/widget', 'element/controller', 'element/overlay', 'element/coord', 'element/camera', 'element/event',]
        }
    ]
};

module.exports = sidebars;
