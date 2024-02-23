import { Provider } from "react-redux";
import { store } from "./store/store";
import HomePage from "./pages/HomePage/HomePage";
import {
  Route,
  HashRouter as Router,
  Routes as Switch,
} from "react-router-dom";

const App = () => {
  return (
    <Provider store={store}>
      <Router>
        <Switch>
          <Route caseSensitive path="/" element={<HomePage />} />
        </Switch>
      </Router>
    </Provider>
  );
};

export default App;
