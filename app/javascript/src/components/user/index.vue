<template>
  <div>
    <v-container>
      <v-toolbar flat color="white">
        <v-toolbar-title>User Lists</v-toolbar-title>
        <v-divider
          class="mx-2"
          inset
          vertical
          >
        </v-divider>
        <v-spacer></v-spacer>
        <v-text-field
          v-model="search"
          append-icon="search"
          label="Search"
          single-line
          hide-details
          ></v-text-field>
        <v-btn @click="dialog = true" color="primary" dark class="mb-2">New User</v-btn>

        <v-dialog v-model="dialog" max-width="500px" persistent>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container grid-list-md>
                <v-layout wrap>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      v-model="editedItem.first_name" 
                      label="First Name">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      v-model="editedItem.last_name" 
                      label="Last Name">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      v-model="editedItem.username" 
                      label="Username">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      v-model="editedItem.email" 
                      label="Email">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      type="password" 
                      v-model="editedItem.password" 
                      label="Password">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      type="password" 
                      v-model="editedItem.password_confirmation" 
                      label="Password Confirmation"
                      >
                    </v-text-field>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" flat @click="save">Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>

      <v-data-table
        :headers="headers"
        :items="users"
        :pagination.sync="pagination"
        :search="search"
        item-key="first_name"
        class="elevation-1"
        prev-icon="arrow_left"
        next-icon="arrow_right"
        sort-icon="arrow_drop_down"
        >

        <template slot="items" slot-scope="props">
          <td class="text-xs-left">{{ props.item.first_name }} {{ props.item.last_name }}</td>
          <td class="text-xs-left">{{ props.item.username }}</td>
          <td class="text-xs-left">{{ props.item.email }}</td>
          <td class="text-xs-left">
            <v-icon
              small
              class="mr-2"
              @click="editItem(props.item)"
              >
              edit
            </v-icon>
              <v-icon
                small
                :disabled="props.item.token === token"
                @click="deleteItem(props.item)"
                >
                delete
              </v-icon>
          </td>
        </template>
      </v-data-table>
    </v-container>

    <div class="text-xs-center">
      <v-dialog
        persistent
        v-model="dialog_load"
        hide-overlay
        persistent
        width="300"
        >
        <v-card
          color="primary"
          dark
          >
          <v-card-text>
            Please stand by
            <v-progress-linear
              indeterminate
              color="white"
              class="mb-0"
              ></v-progress-linear>
          </v-card-text>
        </v-card>
      </v-dialog>
    </div>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      dialog: false,
      dialog_load: false,
      search: '',
      pagination: {
        sortBy: 'first_name'
      },
      headers: [
        { text: 'Name', align: 'left', value: 'first_name', sortable: true },
        { text: 'Username', align: 'left', value: 'username' },
        { text: 'Email', align: 'left', value: 'email' },
        { text: 'Actions', align: 'left', value: 'name', sortable: false }
      ],
      token: '',
      users: [],
      editedIndex: -1,
      editedItem: {
        first_name: '',
        last_name: '',
        username: '',
        email: '',
        password: '',
        password_confirmation: ''
      }
    }
  },
  computed: {
    formTitle () {
      return this.editedIndex === -1 ? 'New User' : 'Edit User'
    }
  },
  watch: {
    dialog (val) {
      val || this.close()
    },
    dialog_load (val) {
      val || this.close()
    }
  },
  created: function() {
    this.currentUser()
    this.fetchUser()
  },
  methods: {
    currentUser () {
      this.token = localStorage.getItem('token')
    },
    fetchUser() {
      this.$http.get("/api/v1/users").then(response => {
        this.users = response.body.data.slice(0.10)
      })
    },
    editItem(item) {
      this.editedIndex = this.users.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },
    deleteItem(item) {
      const index = this.users.indexOf(item)

      swal({
        title: "Delete this user?",
        text: "Are you sure? You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete it!",
      }).then(result => {
        if (result.value) {
          this.$http.delete('/api/v1/users/' + item.id).then(response => {
            this.users.splice(index, 1)
          })
        }
      })
    },
    close() {
      this.dialog = false

      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      }, 300)
    },
    save() {
      this.dialog_load = true

      if (this.editedIndex > -1) {
        var editedId = this.users[this.editedIndex].id
        var edited = Object.assign(this.users[this.editedIndex], this.editedItem)

        this.$http.patch("/api/v1/users/" + editedId, {
          user: edited
        }).then(response => {
          this.fetchUser()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'User has been edited'
          })
        }, response => {
          this.fetchUser()
          this.dialog_load = false
          
          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Registration Error',
            text: key + " " + value
          })
        })
      } else {
        this.$http.post("/api/v1/users", {
          user: this.editedItem
        }).then(response => {
          this.users.push(this.editedItem)
          this.fetchUser()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'User has been added'
          })
        }, response => {
          this.fetchUser()
          this.dialog_load = false

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Registration Error',
            text: key + " " + value
          })
        })
      }
      this.close()
    }
  }
}
</script>
