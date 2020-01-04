import Vue from 'vue';
import App from './App.vue';
import router from './router';
import axios from 'axios';
import VueAxios  from "vue-axios";
// 引入element.ui组件库
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

Vue.use(VueAxios,axios);
Vue.use(ElementUI);

axios.defaults.baseURL = '/api'
axios.defaults.headers.post['Content-Type'] = 'application/json;charset=UTF-8';
Vue.config.productionTip = false

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
