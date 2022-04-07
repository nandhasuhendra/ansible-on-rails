import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'
import VueResource from 'vue-resource'
import Router from '../src/routes'
import Vuetify from 'vuetify'
import "@babel/polyfill"

Vue.use(VueResource)
Vue.use(Vuetify)

import Swal from 'sweetalert2'
window.swal = Swal

import Default from '../src/components/shared/default_layouts.vue'
import Clear from '../src/components/shared/clear_layouts.vue'

Vue.component('default-layout', Default)
Vue.component('clear-layout', Clear)

Vue.http.options.root = "http://127.0.0.1:3000"
Vue.http.interceptors.push(function(request) {
  request.headers.set('Authorization', localStorage.getItem('token'))
  request.headers.set('Accept', 'application/json')

  return function(response) {
    if(response.status === 200 || response.status === 422) {
      return
    }
    if(response.status === 404) {
      return window.location.href = '/404'
    }
    if(response.status === 500) {
      return window.location.href = '/500'
    }
    if(response.status === 401) {
      swal({
        type: 'error',
        title: 'Your seasson has been expired',
        text: 'Something went wrong!',
        confirmButtonText: 'Login'
      }).then((result) => {
        if (result.value) {
          return window.location.href = '/login'
        }
      })
    }
  }
})

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('app'))
  const app = new Vue({
    el,
    render: h => h(App),
    router: Router
  })
})

