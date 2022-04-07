<template>
  <v-app id="inspire">
    <v-content>
      <v-container fluid fill-height>
        <v-layout align-center justify-center>
          <v-flex xs12 sm8 md4>
            <v-card class="elevation-12">
              <v-toolbar dark color="primary">
                <v-toolbar-title>Login form</v-toolbar-title>
                <v-spacer></v-spacer>
                <v-tooltip bottom>
                  <v-btn icon large :href="'/register'" slot="activator" >
                    <v-icon large>person_add</v-icon>
                  </v-btn>
                  <span>Register</span>
                </v-tooltip>
              </v-toolbar>
              <v-card-text>
                <v-form>
                  <v-text-field prepend-icon="person" name="username" label="Username" type="text" v-model="username"></v-text-field>
                  <v-text-field prepend-icon="lock" name="password" label="Password" id="password" type="password" v-model="password"></v-text-field>
                </v-form>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="primary" @click="login">
                  Login
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
export default {
  data: function() {
    return {
      username: '',
      password: ''
    }
  },
  methods: {
    login() {
      this.$http.post('http://127.0.0.1:3000/api/v1/login', {
        auth: {
          username: this.username,
          password: this.password
        }
      }).then(response => {
        localStorage.setItem('token', response.body.auth.token)
        window.location.href="/"
      }, response => {
        swal({
          type: 'error',
          title: 'Login Error',
          text: 'Check your username or password!!',
        })
      })
    }
  }
}
</script>

