import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import VueAxios from "vue-axios";

Vue.use(Vuex);

Vue.use(VueAxios, axios);

export default new Vuex.Store({
  state: {
    data: {}
  },
  mutations: {
    SAVE_DATA(state, data) {
      state.data = data;
    }
  },
  actions: {
    refereshdata({ commit }) {
      Vue.axios
        .get(process.env.VUE_APP_ICINGA_API_URL)
        .then(result => {
          commit("SAVE_DATA", result.data);
        })
        .catch(error => {
          throw new Error(`API ${error}`);
        });
    }
  },
  getters: {
    data: state => state.data
  },
  modules: {}
});
