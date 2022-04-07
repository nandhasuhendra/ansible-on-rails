<template>
  <div id="app">
    <component :is="layout">
      <router-view />
    </component>
  </div>
</template>

<script>
const default_layouts = 'default'

export default {
  name: 'App',
  computed: {
    layout() {
      return(this.$route.meta.layout || default_layouts) + "-layout" 
    }
  }
}
</script>
