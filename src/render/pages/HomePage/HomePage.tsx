import { Layout, Menu } from "antd";
import styles from "./HomePage.module.scss";
import { sidebarItems } from "@/render/config/sidebarItems";
import PomodoroTimerPage from "../PomodoroTimerPage/PomodoroTimerPage";
import { Route, Routes } from "react-router-dom";

const { Content, Sider } = Layout;
const HomePage = () => {
  return (
    <Layout className={styles.container}>
      <Sider className={styles.sider}>
        <Menu
          mode="inline"
          defaultSelectedKeys={["pomodoro"]}
          defaultOpenKeys={["pomodoro"]}
          className={styles.siderMenu}
          items={sidebarItems}
        />
      </Sider>
      <Content className={styles.content}>
        <Routes>
          <Route path="pomodoro" element={<PomodoroTimerPage />} />
        </Routes>
      </Content>
    </Layout>
  );
};

export default HomePage;
