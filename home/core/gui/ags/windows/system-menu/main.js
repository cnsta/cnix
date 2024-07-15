import { Widget } from "../../imports.js";
import PopupWindow from "../../utils/popup_window.js";

import Toggles from "./toggles.js";
import Sliders from "./sliders.js";
import BatteryInfo from "./battery_info.js";

const SystemMenuBox = () =>
  Widget.Box({
    className: "system-menu",
    vertical: true,

    children: [Toggles(), Sliders(), BatteryInfo()],
  });

export default () =>
  PopupWindow({
    monitor: 0,
    anchor: ["top", "right"],
    name: "system-menu",
    child: SystemMenuBox(),
  });
