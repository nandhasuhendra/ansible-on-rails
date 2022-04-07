<template>
  <v-app id="inspire">
    <v-content>
      <v-container fluid fill-height>
        <v-layout align-center justify-center>
          <v-flex xs12 sm8 md4>
            <v-card class="elevation-12">
              <v-toolbar dark color="primary">
                <v-toolbar-title>Register form</v-toolbar-title>
                <v-spacer></v-spacer>
                <v-tooltip bottom>
                  <v-btn icon large :href="'/login'" slot="activator" >
                    <v-icon large>person</v-icon>
                  </v-btn>
                  <span>Login</span>
                </v-tooltip>
              </v-toolbar>
              <v-card-text>
                <v-form>
                  <v-text-field 
                    prepend-icon="person" 
                    name="first_name" 
                    label="First Name" 
                    type="text" 
                    v-model="user.first_name"
                    >
                  </v-text-field>
                  <v-text-field 
                    prepend-icon="person" 
                    name="last_name" 
                    label="Last Name" 
                    type="text" 
                    v-model="user.last_name"
                    >
                  </v-text-field>
                  <v-text-field 
                    prepend-icon="person" 
                    name="username" 
                    label="Username" 
                    type="text"
                    v-model="user.username"
                    >
                  </v-text-field>
                  <v-text-field
                    prepend-icon="email" 
                    name="email" 
                    label="Email"
                    type="email" 
                    v-model="user.email"
                    >
                  </v-text-field>
                  <v-text-field 
                    prepend-icon="lock"
                    name="password"
                    label="Password"
                    type="password" 
                    v-model="user.password"
                    >
                  </v-text-field>
                  <v-text-field
                    prepend-icon="lock" 
                    name="password_confirmation" 
                    label="Password Confirmation"
                    type="password"
                    v-model="user.password_confirmation"
                    >
                  </v-text-field>
                </v-form>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="primary" type="submit"  @click="register">
                  Register
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
      user: {
        first_name: '',
        last_name: '',
        username: '',
        email: '',
        password: '',
        password_confirmation: ''
      }
    }
  },
  methods: {
    register(){
      this.$http.post('http://127.0.0.1:3000/api/v1/register', {
        user: this.user
      }).then(response => {
        swal({
          type: 'success',
          title: 'Registration success',
          text: 'Go to login page?',
        }).then(function() {
          window.location.href = "/login"
        })
      }, response => {
        var key = Object.keys(response.body.data)[0]
        var value = Object.values(response.body.data[key])[0]

        swal({
          type: 'error',
          title: 'Registration Error',
          text: key + " " + value
        })
      })
    }
  }
}
</script>
