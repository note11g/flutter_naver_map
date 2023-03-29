import React from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';

import styles from './index.module.css';


function GridItem(props) {
    return <Link className={styles.gridItem} to={"/element/" + props.to}>
        <h2>{props.title}</h2>
        <span>{props.description}</span>
    </Link>;
}

export default function Home(): JSX.Element {
    const {siteConfig} = useDocusaurusContext();
    return (
        <Layout
            title={`flutter_naver_map docs`}
            description="flutter_naver_map docs">
            <>
                <main>
                    <div className="container custom-container">
                        <h2>문서는 현재 작업중입니다.</h2>
                        <p>아직 작성되지 않은 부분이 있거나, 최신 버전과 맞지 않는 부분이 있을 수 있으니 유의 바랍니다.</p>
                    </div>
                    <hr/>
                    <div className="container custom-container">
                        <h1>시작하기</h1>
                        <p>초기 설정은 어떻게 해야할까요?<br/>간단한 시작 가이드와 영상 시작 가이드가 준비되어 있어요!</p>
                        <div className={styles.buttons}>
                            <Link className="button button--secondary" to="start">
                                간단 시작 가이드
                            </Link>
                            <a href="https://youtube.com" target="_blank" className="button button--secondary">
                                영상 시작 가이드
                            </a>
                        </div>
                    </div>
                    <div className="container custom-container">
                        <h1>핵심 구성요소</h1>
                        <p>flutter_naver_map를 사용할 때, 가장 핵심적인 요소들이에요.<br/>각 요소를 클릭하면 설명과 함께 사용법을 익힐 수 있어요.</p>
                        <div className={styles.grid}>
                            <GridItem
                                to="widget"
                                title="위젯"
                                description="네이버 지도를 플러터에서 배치할 수 있어요"
                            />
                            <GridItem
                                to="controller"
                                title="컨트롤러"
                                description="배치된 지도를 컨트롤할 수 있어요"
                            />
                            <GridItem
                                to="overlay"
                                title="오버레이"
                                description="지도에 그릴 수 있는 것으로, 대표적으로 마커나 경로가 있어요"
                            />
                            <GridItem
                                to="coord"
                                title="좌표"
                                description="위도와 경도를 통해 위치 혹은 범위를 나타낼 수 있어요"
                            />
                            <GridItem
                                to="camera"
                                title="카메라"
                                description="지도 영역이 어떻게 보일지 컨트롤할 수 있어요"
                            />
                            <GridItem
                                to="event"
                                title="이벤트"
                                description="지도의 상태 변경, 사용자의 터치 이벤트 등을 받을 수 있어요"
                            />
                        </div>
                    </div>
                </main>
            </>
        </Layout>
    );
}
