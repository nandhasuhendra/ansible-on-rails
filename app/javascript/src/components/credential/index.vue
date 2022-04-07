<template>
  <div>
    <v-container>
      <v-toolbar flat color="white">
        <v-toolbar-title>Credential Lists</v-toolbar-title>
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
        <v-btn @click="dialog = true" color="primary" dark class="mb-2">Generate New Key</v-btn>

        <v-dialog v-model="dialog" max-width="500px" persistent>
          <v-card>
            <v-card-title>
              <span class="headline">New Credential</span>
            </v-card-title>

            <v-card-text>
              <v-container grid-list-md>
                <v-layout wrap>
                  <v-flex xs12 sm6 md6>
                    <v-text-field 
                      v-model="editedItem.name" 
                      label="Name">
                    </v-text-field>
                  </v-flex>
                  <v-flex xs12 sm6>
                    <v-select
                      :items="items"
                      v-model="editedItem.key_type" 
                      label="Standard"
                      ></v-select>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" flat @click="save">Generate</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>

      <v-data-table
        :headers="headers"
        :items="credentials"
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
          <td class="text-xs-left">{{ props.item.key_type }}</td>
          <td class="text-xs-left">{{ props.item.file_name }}</td>
          <td class="text-xs-left">
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
        sortBy: 'name'
      },
      headers: [
        { text: 'Name', align: 'left', value: 'name', sortable: true },
        { text: 'Type', align: 'left', value: 'key_type', sortable: false },
        { text: 'File Name', align: 'left', value: 'file_name', sortable: false },
        { text: 'Actions', align: 'left', value: 'name', sortable: false }
      ],
      items: ['RSA'],
      credentials: [],
      editedIndex: -1,
      editedItem: {
        name: '',
        key_type: ''
      }
    }
  },
  computed: {
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
    this.fetchCredential()
  },
  methods: {
    fetchCredential() {
      this.$http.get("/api/v1/credentials").then(response => {
        this.credentials = response.body.data.slice(0.10)
      })
    },
    editItem(item) {
      this.editedIndex = this.credentials.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },
    deleteItem(item) {
      const index = this.credentials.indexOf(item)

      swal({
        title: "Delete this credential?",
        text: "Are you sure? You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete it!",
      }).then(result => {
        if (result.value) {
          this.$http.delete("/api/v1/credentials/" + item.id).then(response => {
            this.credentials.splice(index, 1)
          })
        }
      })
    },
    close() {
      this.dialog = false
      this.dialog_load = false

      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      }, 300)
    },
    save() {
      this.dialog_load = true

      if (this.editedIndex > -1) {
        swal({
          type: 'error',
          title: 'Credential is not ready'
        })
      } else {
        this.$http.post("/api/v1/credentials", {
          credential: this.editedItem
        }).then(response => {
          this.credentials.push(this.editedItem)
          this.fetchCredential()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'Credential has been added'
          })
        }, response => {
          this.fetchCredential()
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
