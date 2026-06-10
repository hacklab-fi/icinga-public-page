import { createApp } from "vue";
import moment from "moment";
import "./assets/base.css";
import App from "./App.vue";
import router from "./router";
import store from "./store";

const app = createApp(App);

// Exposed as `moment` inside templates (used by Status.vue for downtime timestamps).
app.config.globalProperties.moment = moment;

app.use(router).use(store).mount("#app");
