<template>
  <nav>
    <v-toolbar app fixed dark clipped-left color="primary">
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-toolbar-title>Ansible</v-toolbar-title>
      <v-spacer></v-spacer>

      <v-tooltip bottom>
        <v-btn medium slot="activator" color="success" @click="logout">
          Logout
          <v-icon medium right>exit_to_app</v-icon>
        </v-btn>

        <span>Logout</span>
      </v-tooltip>
    </v-toolbar>

    <v-navigation-drawer clipped fixed v-model="drawer" app >
      <v-list dense>
        <template v-for="item in items">
          <v-list-group v-if="item.children" v-model="item.model" :key="item.text" :prepend-icon="item.model ? item.icon : item['icon-alt']" append-icon="" >
            <v-list-tile slot="activator">
              <v-list-tile-content>
                <v-list-tile-title>
                  {{ item.text }}
                </v-list-tile-title>
              </v-list-tile-content>
            </v-list-tile>

            <v-list-tile v-for="(child, i) in item.children" :key="i" :to="child.link" @click="" >
              <v-list-tile-action v-if="child.icon">
                <v-icon>{{ child.icon }}</v-icon>
              </v-list-tile-action>

              <v-list-tile-content>
                <v-list-tile-title>
                  {{ child.text }}
                </v-list-tile-title>
              </v-list-tile-content>
            </v-list-tile>
          </v-list-group>

          <v-list-tile v-else @click="" :key="item.text" :to="item.link">
            <v-list-tile-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-tile-action>

            <v-list-tile-content>
              <v-list-tile-title>
                {{ item.text }}
              </v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
        </template>
      </v-list>
    </v-navigation-drawer>
  </nav>
</template>

<script>
  export default{
    data: () => ({
      dialog: false,
      drawer: null,
      items: [
        { icon: 'dashboard', text: 'Dashboard', link: '/dashboard' },
        { icon: 'person', text: 'User', link: '/users' },
        {
          icon: 'keyboard_arrow_up',
          'icon-alt': 'storage',
          text: 'Inventories',
          model: false,
          children: [
            { icon: 'computer', text: 'Hosts', link: '/hosts' },
            { icon: 'devices', text: 'Groups', link: '/groups' },
            { icon: 'vpn_key', text: 'Credentials', link: '/credentials' },
            { icon: 'description', text: 'tasks', link: '/tasks' },
          ]
        },
        { icon: 'description', text: 'Logs', link: '/logs' }
      ]
    }),
    methods: {
      logout() {
        localStorage.removeItem('token')

        window.location.href="/login"
      }
    }
  }
</script>

