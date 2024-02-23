import { MenuProps } from "antd";
import { NavLink } from "react-router-dom";

export const sidebarItems: MenuProps["items"] = [
  {
    label: <NavLink to="/pomodoro">Pomodoro Timer</NavLink>,
    key: "pomodoro",
  },
];
