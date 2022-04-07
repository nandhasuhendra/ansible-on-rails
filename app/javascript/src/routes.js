import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Dashboard from './components/dashboard.vue'
import Login from './components/authentications/login.vue'
import Register from './components/authentications/register.vue'
import UserIndex from './components/user/index.vue'
import HostIndex from './components/host/index.vue'
import GroupIndex from './components/group/index.vue'
import CredentialIndex from './components/credential/index.vue'
import TaskIndex from './components/task/index.vue'
import LogIndex from './components/log/index.vue'
import Error500 from './components/errors/500.vue'
import Error404 from './components/errors/404.vue'

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    { 
      path: '/', 
      name: 'root',
      redirect: '/dashboard'
    },
    { 
      path: '/login', 
      name: 'login', 
      meta: { requiresAuth: false, layout: 'clear' }, 
      component: Login 
    },
    { 
      path: '/register', 
      name: 'register', 
      meta: { requiresAuth: false, layout: 'clear' }, 
      component: Register 
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      meta: { requiresAuth: true, layout: 'default' }, 
      component: Dashboard
    },
    { 
      path: '/users', 
      name: 'users', 
      meta: { requiresAuth: true, layout: 'default' }, 
      component: UserIndex 
    },
    { 
      path: '/hosts', 
      name: 'hosts', 
      meta: { requiresAuth: true, layout: 'default' }, 
      component: HostIndex 
    },
    { 
      path: '/groups', 
      name: 'groups', 
      meta: { requiresAuth: true, layout: 'default' }, 
      component: GroupIndex 
    },
    { 
      path: '/credentials', 
      name: 'credentials', 
      meta: { requiresAuth: true, layout: 'default' }, 
      component: CredentialIndex 
    },
    { 
      path: '/tasks', 
      name: 'tasks', 
      meta: { requiresAuth: true, layout: 'default' }, 
      component: TaskIndex 
    },
    { 
      path: '/logs', 
      name: 'logs', 
      meta: { requiresAuth: true, layout: 'default' }, 
      component: LogIndex 
    },
    { 
      path: '/500', 
      meta: { requiresAuth: true,  layout: 'clear' }, 
      component: Error500 
    },
    { 
      path: '/404', 
      meta: { requiresAuth: true,  layout: 'clear' }, 
      component: Error404 
    },
    { path: '*', redirect: '/404' }
  ]
})

router.beforeEach((to, from, next) => {
  var requiresAuth = to.matched.some( record => record.meta.requiresAuth )

  if( requiresAuth && checkToken() == false ) {
    next('/login')
  } else if ( !requiresAuth && checkToken() == true ) {
    next('/dashboard')
  } else {
    next()
  }
})

function checkToken() {
  var token = window.localStorage.getItem('token')
  var statusToken = false

  if(token !== null) {
    var expiredToken = JSON.parse(atob(token.split('.')[1]))
    var currentTime  = Date.now() / 1000 | 0

    if( currentTime < expiredToken.exp ) {
      statusToken = true
    } else {
      statusToken = false
    }
  } else {
    statusToken = false
  }

  return statusToken
}


export default router
