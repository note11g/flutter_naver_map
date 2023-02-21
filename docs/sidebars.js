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
            items: [
                'element/widget',
                'element/controller',
                {
                    type: "category",
                    label: "오버레이",
                    link: {
                        id: "element/overlay/overlay",
                        type: "doc",
                    },
                    items: [
                        'element/overlay/marker',
                        'element/overlay/info_window',
                        'element/overlay/shape_overlay',
                        'element/overlay/ground_overlay',
                        'element/overlay/path_overlay',
                        'element/overlay/location_overlay',
                    ],
                },
                'element/coord',
                'element/camera',
                'element/event'
            ],
        }
    ]
};

module.exports = sidebars;
