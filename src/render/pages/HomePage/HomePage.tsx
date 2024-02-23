import { Button } from "antd";
import styles from "./HomePage.module.scss";
const HomePage = () => {
  return (
    <div className={styles.container}>
      <h1 className={styles.text}>Text</h1>
      <Button>Test</Button>
    </div>
  );
};

export default HomePage;
