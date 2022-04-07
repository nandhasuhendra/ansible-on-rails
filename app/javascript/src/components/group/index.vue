<template>
  <div>
    <v-container>
      <v-toolbar flat color="white">
        <v-toolbar-title>Group Lists</v-toolbar-title>
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
        <v-btn @click="dialog = true" color="primary" dark class="mb-2">New Group</v-btn>

        <v-dialog v-model="dialog" max-width="500px" persistent>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-tabs
              centered
              slider-color="primary"
              >

              <v-tab href="#tab-1">
                Form
              </v-tab>

              <v-tab href="#tab-2">
                input Members
              </v-tab>

              <v-tab href="#tab-3">
                input Credential
              </v-tab>

              <v-tab-item value="tab-1">
                <v-card flat>
                  <v-card-text>
                    <v-container grid-list-md>
                      <v-layout wrap>
                        <v-flex xs12 sm12 md12>
                          <v-text-field 
                                v-model="editedItem.name" 
                                label="Name">
                          </v-text-field>
                        </v-flex>
                        <v-flex xs12 sm12 md12>
                          <v-text-field 
                                v-model="editedItem.descriptions" 
                                label="Descriptions">
                          </v-text-field>
                        </v-flex>
                      </v-layout>
                    </v-container>
                  </v-card-text>
                </v-card>
              </v-tab-item>

              <v-tab-item value="tab-2">
                <v-card flat>
                  <v-card-text>
                    <v-flex xs12>
                      <v-combobox
                        v-model="selectedHost"
                        :items="hosts"
                        :item-text="text"
                        :key="hosts.id"
                        label="Select Host"
                        multiple
                        chips
                        clearable
                        >
                      </v-combobox>
                    </v-flex>
                  </v-card-text>
                </v-card>
              </v-tab-item>

              <v-tab-item value="tab-3">
                <v-card flat>
                  <v-card-text>
                    <v-flex xs12 sm12>
                      <v-combobox
                        :disabled="isFilled"
                        v-model="selectedKey" 
                        :items="credentials"
                        :item-text="text"
                        :key="credentials.id"
                        label="Credential Names"
                        chips
                        ></v-combobox>
                    </v-flex>
                  </v-card-text>
                </v-card>
              </v-tab-item>
            </v-tabs>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" flat @click="save" :disabled='!isComplete'>Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>

      <v-data-table
        :headers="headers"
        :items="groups"
        :pagination.sync="pagination"
        :search="search"
        item-key="name"
        class="elevation-1"
        prev-icon="arrow_left"
        next-icon="arrow_right"
        sort-icon="arrow_drop_down"
        >

        <template slot="items" slot-scope="props">
          <tr @click="props.expanded = !props.expanded; fetchHostList(props.item.group_members)">
            <td class="text-xs-left">{{ props.item.name }}</td>
            <td class="text-xs-left">{{ props.item.descriptions }}</td>
            <td class="text-xs-left">
              <v-icon
                small
                class="mr-2"
                @click="editItem(props.item); fetchSelectedHost(props.item.group_members), fetchSelectedKey(props.item.credential_id)"
                >
                edit
              </v-icon>
              <v-icon
                small
                class="mr-2"
                @click="setup(props.item)"
                >
                build
              </v-icon>
              <v-icon
                small
                class="mr-2"
                @click="run(props.item)"
                >
                device_hub
              </v-icon>
              <v-icon
                small
                class="mr-2"
                @click="deleteItem(props.item)"
                >
                delete
              </v-icon>
            </td>
          </tr>
        </template>

        <template slot="expand" slot-scope="props">
          <v-container grid-list-md>
            <v-layout row wrap text-xs-center>
              <v-flex xs12 sm3 v-for="(h, index) in props.item.group_members" :key="index">
                <v-card to="/hosts">
                  <v-card-text class="font-weight-bold">{{ h.host.name }}</v-card-text>
                  <v-card-text>{{ h.host.ip_address }}</v-card-text>
                  <v-alert
                    :value="true"
                    v-bind:type="buildStatus[index]"
                    >
                    {{ h.build_status }}
                  </v-alert>
                  <v-alert
                    :value="true"
                    v-bind:type="pingStatus[index]"
                    >
                    {{ h.ping_status }}
                  </v-alert>
                </v-card>
              </v-flex>
            </v-layout>
          </v-container>
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

    <div class="text-xs-center">
      <v-dialog v-model="dialog_result" persistent max-width="500px">
        <v-container>
          <v-card>
            <v-card-title
              class="headline grey lighten-2"
              primary-title
              >
              Result
            </v-card-title>

            <v-container grid-list-md>
              <v-layout row wrap text-xs-center v-for="r in result">
                <v-flex xs6 sm6>
                  <v-card-text>
                    {{ r.host }}
                  </v-card-text>
                </v-flex>

                <v-flex xs6 sm6>
                  <v-card-text v-bind:class="checkResult(r)">
                    <span class="white--text">{{ r.status }}</span>
                  </v-card-text>
                </v-flex>
              </v-layout>
            </v-container>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Close</v-btn>
            </v-card-actions>
          </v-card>
        </v-container>
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
      dialog_result: false,
      search: '',
      pagination: {
        sortBy: 'updated_at',
        descending: true
      },
      headers: [
        { text: 'Group Name', align: 'left', value: 'name', sortable: true },
        { text: 'Descriptions', align: 'left', value: 'name', sortable: false },
        { text: 'Actions', align: 'left', value: 'name', sortable: false }
      ],
      groups: [],
      hosts: [],
      credentials: [],
      hostList: [],
      selectedHost: [],
      selectedKey: "",
      editedIndex: -1,
      editedItem: {
        name: '',
        descriptions: '',
        credential_id: ''
      },
      result: [],
      buildStatus: [],
      pingStatus: []
    }
  },
  computed: {
    formTitle () {
      return this.editedIndex === -1 ? 'New Group' : 'Edit Group'
    },
    isComplete () {
      return this.editedItem.name && this.editedItem.descriptions
    },
    isFilled() {
      if (this.editedItem.credential_id ) return true
    }
  },
  watch: {
    dialog (val) {
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
    this.fetchGroup()
    this.fetchHost()
    this.fetchCredential()
    this.fetchHostList(null)
    this.fetchSelectedHost(null)
    this.fetchSelectedKey(null)
  },
  methods: {
    text: hosts => hosts.name,
    checkResult(item) {
      if(item.status.trim() !== 'Success' ) {
        return 'error'
      } else {
        return 'success'
      }
    },
    fetchGroup() {
      this.$http.get("/api/v1/groups").then(response => {
        this.groups = response.body
      })
    },
    fetchHost() {
      this.$http.get("/api/v1/hosts").then(response => {
        this.hosts = response.body.data
      })
    },
    fetchCredential() {
      this.$http.get("/api/v1/credentials").then(response => {
        this.credentials = response.body.data
      })
    },
    fetchHostList(item) {
      try {
        this.hostList = []
        this.buildStatus = []
        this.pingStatus = []

        for(var index in item) {
          this.hostList.push(item[index].host)

          if(item[index].build_status.trim() !== 'Success') {
            this.buildStatus.push('error')
          } else {
            this.buildStatus.push('success')
          }

          if(item[index].ping_status.trim() !== 'Success') {
            this.pingStatus.push('error')
          } else {
            this.pingStatus.push('success')
          }
        }
      } catch(error) {
        return true
      }
    },
    fetchSelectedHost(item) {
      try {
        this.selectedHost = []

        for(var index in item) {
          this.selectedHost.push(item[index].host)
        }
      } catch(error) {
        return true
      }
    },
    fetchSelectedKey(item) {
      try {
        this.selectedKey = ""
        
        for(var i in this.credentials) {
          this.credentials[i].id === item ? this.selectedKey = this.credentials[i] : ""
        }
      } catch(error) {
        return true
      }
    },
    editItem(item) {
      this.editedIndex = this.groups.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },
    deleteItem(item) {
      const index = this.groups.indexOf(item)

      swal({
        title: "Delete this group?",
        text: "Are you sure? You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete it!",
      }).then(result => {
        if (result.value) {
          this.$http.delete('/api/v1/groups/' + item.id).then(response => {
            this.groups.splice(index, 1)
          })
        }
      })
    },
    close() {
      this.dialog = false
      this.dialog_load = false
      this.dialog_result = false

      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.selectedHost = null
        this.selectedKey = null
        this.editedIndex = -1
      }, 300)
    },
    save() {
      this.dialog_load = true

      var host_ids = []
      var key_id = ""
      
      if (this.editedIndex > -1) {
        var editedId = this.groups[this.editedIndex].id
        var edited = Object.assign(this.groups[this.editedIndex], this.editedItem)

        for(var host in this.selectedHost) {
          host_ids.push(this.selectedHost[host].id)
        }

        this.selectedKey === undefined ? "" : key_id = this.selectedKey.id

        this.$http.patch("/api/v1/groups/" + editedId, {
          group: {
            name: this.editedItem.name,
            descriptions: this.editedItem.descriptions,
            credential_id: key_id,
            host_ids: host_ids
          }
        }).then(response => {
          this.fetchGroup()

          swal({
            type: 'success',
            title: 'Group has been edited'
          })
        }, response => {
          this.fetchGroup()

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Edit Group Error',
            text: key + " " + value
          })
        })
      } else {
        for(var host in this.selectedHost) {
          host_ids.push(this.selectedHost[host].id)
        }

        this.selectedKey === undefined ? "" : key_id = this.selectedKey.id

        this.$http.post("/api/v1/groups", {
          group: {
            name: this.editedItem.name,
            descriptions: this.editedItem.descriptions,
            credential_id: key_id,
            host_ids: host_ids
          }
        }).then(response => {
          this.groups.push(this.editedItem)
          this.fetchGroup()

          swal({
            type: 'success',
            title: 'Group has been added'
          })
        }, response => {
          this.fetchGroup()

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Add Group Error',
            text: key + " " + value
          })
        })
      }
      this.close()
    },
    checking(item) {
      if(item.credential_id && item.group_members) return true

      return false
    },
    setup(item) {
      if(this.checking(item)) {
        this.dialog_load = true

        var setupId = item.id
        var keyId = item.credential_id


        this.$http.post("/api/v1/groups/setup/" + setupId, {
          group: {
            credential_id: keyId
          }
        }).then(response => {
          this.fetchGroup()
          this.dialog_result = true

          this.result = response.body.data
        }, response => {
          this.fetchGroup()
          swal({
            type: 'error',
            title: 'Setup failed',
            text: response.body.data
          })
        })
      } else {
        swal({
          type: 'error',
          title: 'Setup failed',
          text: 'Check your Credential and Host members'
        })
      }
    },
    run (item) {
      if(this.checking(item)) {
        this.dialog_load = true

        this.$http.post("/api/v1/ping", {
          ansible: { group_id: item.id, name: item.name, file_path: 'group' }
        }).then(response => {
          this.fetchGroup()
          this.result = response.body.data

          this.dialog_result = true
        })
      } else {
        this.fetchGroup()

        swal({
          type: 'error',
          title: 'Setup failed',
          text: 'Check your Credential and Host members'
        })
      }
    }
  }
}
</script>
