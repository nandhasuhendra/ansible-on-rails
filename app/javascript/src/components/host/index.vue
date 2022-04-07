<template>
  <div>
    <v-container>
      <v-toolbar flat color="white">
        <v-toolbar-title>Host Lists</v-toolbar-title>
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
        <v-btn @click="dialog_1 = true" color="primary" dark class="mb-2">New Host</v-btn>

        <v-dialog v-model="dialog_1" max-width="500px" persistent>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container grid-list-md>
                <v-layout wrap>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                      v-model="editedItem.name" 
                      label="Hostname">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                      v-model="editedItem.ip_address" 
                      label="IP Address">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                      v-model="editedItem.port" 
                      label="Port"
                      hint="Default port 22"
                      persistent-hint>
                    </v-text-field>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" flat @click="save" :disabled='!isComplete'>Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <v-dialog v-model="dialog_2" max-width="500px" persistent>
          <v-card>
            <v-card-text>
              <v-container grid-list-md>
                <v-layout wrap>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                          v-model="setupedItem.user" 
                          label="SSH User">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                          v-model="setupedItem.password" 
                          type="password"
                          label="Password">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                          v-model="setupedItem.sudo_pass" 
                          type="password"
                          label="Sudo Password">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                          v-model="setupedItem.ip_address" 
                          label="IP Address">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm12 md12>
                    <v-text-field 
                          v-model="setupedItem.port" 
                          label="Port">
                    </v-text-field>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" flat @click="send" :disabled='!isComplete'>Send</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
      

      <v-data-table
        :headers="headers"
        :items="hosts"
        :pagination.sync="pagination"
        :search="search"
        item-key="name"
        class="elevation-1"
        prev-icon="arrow_left"
        next-icon="arrow_right"
        sort-icon="arrow_drop_down"
        >

        <template slot="items" slot-scope="props">
          <td class="text-xs-left">{{ props.item.name }}</td>
          <td class="text-xs-left">{{ props.item.ip_address }}</td>
          <td class="text-xs-left">{{ props.item.port }}</td>
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
              slot="activator"
              class="mr-2"
              @click="setupItem(props.item)"
              >
              build
            </v-icon>
            <v-icon
              small
              class="mr-2"
              @click="run(props.item.name)"
              >
              device_hub
            </v-icon>
              <v-icon
                small
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
        v-model="dialog_load"
        persistent
        width="300"
        >
        <v-card
          color="primary"
          dark
          >
          <v-card-text>
            please stand by
            <v-progress-linear
              indeterminate
              color="white"
              class="mb-0"
              ></v-progress-linear>
          </v-card-text>
        </v-card>
      </v-dialog>
    </div>

    <div class="text-xs-center">
      <v-dialog v-model="dialog_result" persistent width="500px">
        <v-card>
          <v-card-title class="headline grey lighten-2" primary-title>
            Ansible Result
          </v-card-title>

          <v-container grid-list-md>
            <v-layout row wrap text-xs-center v-model="result">
              <v-flex xs6 sm6>
                <v-card-text>
                  {{ result.host }}
                </v-card-text>
              </v-flex>

              <v-flex xs6 sm6>
                <v-card-text v-bind:class="checkResult(result.status)">
                  <span class="white--text">{{ result.status }}</span>
                </v-card-text>
              </v-flex>
            </v-layout>
          </v-container>

          <v-divider></v-divider>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" flat @click="close">Close</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </div>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      dialog_1: false,
      dialog_2: false,
      dialog_load: false,
      dialog_result: false,
      search: '',
      pagination: {
        sortBy: 'name'
      },
      headers: [
        { text: 'Hostname', align: 'left', value: 'name' },
        { text: 'IP Address', align: 'left', value: 'ip_address' },
        { text: 'Port', align: 'left', value: 'port' },
        { text: 'Actions', align: 'left', value: 'name', sortable: false }
      ],
      hosts: [],
      editedIndex: -1,
      editedItem: {
        name: '',
        ip_address: '',
        port: ''
      },
      setupedIndex: -1,
      setupedItem: {
        user: '',
        password: '',
        sudo_pass: '',
        ip_address: '',
        port: ''
      },
      result: []
    }
  },
  computed: {
    formTitle () {
      return this.editedIndex === -1 ? 'New Host' : 'Edit Host'
    },
    isComplete () {
      return this.editedItem.name && this.editedItem.ip_address && this.editedItem.port || 
        this.setupedItem.user && this.setupedItem.password && this.setupedItem.sudo_pass && this.setupedItem.ip_address && this.setupedItem.port
    }
  },
  watch: {
    dialog_1 (val) {
      val || this.close()
    },
    dialog_2 (val) {
      val || this.close()
    },
    dialog_load (val) {
      val || this.close()
    },
    dialog_result (val) {
      val || this.close()
    }
  },
  created: function() {
    this.fetchHost()
  },
  methods: {
    checkResult(item) {
      if(item === undefined || item.trim() !== 'Success' ) {
        return 'error'
      } else {
        return 'success'
      }
    },
    fetchHost() {
      this.$http.get("/api/v1/hosts").then(response => {
        this.hosts = response.body.data.slice(0.10)
      })
    },
    editItem(item) {
      this.editedIndex = this.hosts.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog_1 = true
    },
    setupItem(item) {
      var items = { ip_address: item.ip_address, port: item.port }
      this.setupedItem = Object.assign({}, items)
      this.dialog_2 = true
    },
    deleteItem(item) {
      const index = this.hosts.indexOf(item)

      swal({
        title: "Delete this host?",
        text: "Are you sure? You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete it!",
      }).then(result => {
        if (result.value) {
          this.$http.delete('/api/v1/hosts/' + item.id).then(response => {
            this.hosts.splice(index, 1)
          })
        }
      })
    },
    close() {
      this.dialog_1 = false
      this.dialog_2 = false
      this.dialog_load = false
      this.dialog_result = false

      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      }, 300)
    },
    save() {
      this.dialog_load = true

      if (this.editedIndex > -1) {
        var editedId = this.hosts[this.editedIndex].id
        var edited = Object.assign(this.hosts[this.editedIndex], this.editedItem)

        this.$http.patch("/api/v1/hosts/" + editedId, {
          host: edited
        }).then(response => {
          this.fetchHost()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'Host has been edited'
          })
        }, response => {
          this.fetchHost()
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
        this.$http.post("/api/v1/hosts", {
          host: this.editedItem
        }).then(response => {
          this.hosts.push(this.editedItem)
          this.fetchHost()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'Host has been added'
          })
        }, response => {
          this.fetchHost()
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
    },
    send() {
      this.dialog_load = true

      this.$http.post("/api/v1/default", {
        ssh: this.setupedItem
      }).then(response => {
        this.close()
        var key = response.body.data

        swal({
          type: 'success',
          title: 'Setup success',
          text: key
        })
      }, response => {
        this.close()
        var key = response.body.data

        swal({
          type: 'error',
          title: 'Setup Error',
          text: key
        })
      })
    },
    run(item) {
      this.dialog_load = true

      this.$http.post("/api/v1/ping", {
        ansible: { name: item, file_path: 'host' }
      }).then(response => {
        this.result = response.body.data[0]
    
        this.dialog_result = true
      })
    }
  }
}
</script>
