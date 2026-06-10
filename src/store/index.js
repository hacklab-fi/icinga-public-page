import { createStore } from "vuex";
import axios from "axios";

const API_URL = import.meta.env.VITE_ICINGA_API_URL;

export default createStore({
  state: {
    data: {},
    updatedAt: null
  },
  mutations: {
    SAVE_DATA(state, data) {
      state.data = data;
      state.updatedAt = Date.now();
    }
  },
  actions: {
    refreshData({ commit }) {
      return axios
        .get(API_URL)
        .then(result => {
          // The upstream PHP proxy can prepend a deprecation warning to the body, e.g.
          //   <br /><b>Warning</b>: ... icinga-public.php on line 121<br />{ ...json... }
          // That makes the response invalid JSON, so axios hands us the raw string instead
          // of a parsed object. Strip anything before the first '{' and parse defensively.
          // Fixed upstream in OH6AD/oikopupu#6 (merged, awaiting deploy); kept here as a
          // belt-and-suspenders guard — once the server serves clean JSON this branch no-ops.
          const raw = result.data;
          const data =
            typeof raw === "string"
              ? JSON.parse(raw.slice(raw.indexOf("{")))
              : raw;
          commit("SAVE_DATA", data);
        })
        .catch(error => {
          throw new Error(`API ${error}`);
        });
    }
  },
  getters: {
    data: state => state.data,
    updatedAt: state => state.updatedAt
  }
});
