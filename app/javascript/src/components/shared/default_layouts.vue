<template>
  <v-app id="inspire">
    <AppNavbar></AppNavbar>
    <v-content>
      <v-container fluid>
        <slot />
      </v-container>
    </v-content>
    <AppFooter></AppFooter>
  </v-app>
</template>

<script>
import AppNavbar from './_app_navbar.vue'
import AppFooter from './_app_footer.vue'

export default {
  name: 'App',
  components: {
    AppNavbar,
    AppFooter
  }
}
</script>
