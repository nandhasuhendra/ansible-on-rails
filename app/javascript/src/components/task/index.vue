<template>
  <div>
    <v-container>
      <v-toolbar flat color="white">
        <v-toolbar-title>Task Lists</v-toolbar-title>
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
        <v-btn @click="dialog = true" color="primary" dark class="mb-2">New Task</v-btn>

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
                Create Task
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
                    <v-flex xs12 sm12>
                      <editor v-model="editedItem.task" @init="editorInit" lang="yaml" theme="chrome" width="450" height="300"></editor>
                    </v-flex>

		    </br>
                    <p>
                      more info about ansible playbook visit: <a href="https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html ">This link</a>
                    </p>
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
        :items="tasks"
        :pagination.sync="pagination"
        :search="search"
        item-key="name"
        class="elevation-1"
        prev-icon="arrow_left"
        next-icon="arrow_right"
        sort-icon="arrow_drop_down"
        >

        <template slot="items" slot-scope="props">
          <tr>
            <td class="text-xs-left">{{ props.item.name }}</td>
            <td class="text-xs-left">{{ props.item.descriptions }}</td>
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
                class="mr-2"
                @click="deleteItem(props.item)"
                >
                delete
              </v-icon>
            </td>
          </tr>
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
  </div>
</template>

<script>
import AceEditorOnVue from 'vue2-ace-editor'

export default {
  components: {
    'editor': AceEditorOnVue
  },
  data: function() {
    return {
      dialog: false,
      dialog_load: false,
      search: '',
      pagination: {
        sortBy: 'updated_at',
        descending: true
      },
      headers: [
        { text: 'Task Name', align: 'left', value: 'name', sortable: true },
        { text: 'Descriptions', align: 'left', value: 'name', sortable: false },
        { text: 'Actions', align: 'left', value: 'name', sortable: false }
      ],
      tasks: [],
      editedIndex: -1,
      editedItem: {
        name: '',
        descriptions: '',
        task: ''
      }
    }
  },
  computed: {
    formTitle () {
      return this.editedIndex === -1 ? 'New Task' : 'Edit Task'
    },
    isComplete () {
      return this.editedItem.name && this.editedItem.descriptions
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
    this.fetchTask()
  },
  methods: {
    text: groups => groups.name,
    editorInit: function (editor) {
      require('brace/ext/language_tools')
      require('brace/mode/yaml')
      require('brace/theme/chrome')
      require('brace/snippets/yaml')

      editor.setOption("useSoftTabs", true)
      editor.setOption("tabSize", 2)
      editor.setOption("minLines", 5)
      editor.setOption("maxLines", 15)
      editor.setOption("fontSize", "12pt")
      editor.setOption("highlightActiveLine", true)
      editor.setOption("AutoScrollEditorIntoView", true)
    },
    fetchTask() {
      this.$http.get("/api/v1/tasks").then(response => {
        this.tasks = response.body.data
      })
    },
    editItem(item) {
      this.editedIndex = this.tasks.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },
    deleteItem(item) {
      const index = this.tasks.indexOf(item)

      swal({
        title: "Delete this task?",
        text: "Are you sure? You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete it!",
      }).then(result => {
        if (result.value) {
          this.$http.delete('/api/v1/tasks/' + item.id).then(response => {
            this.tasks.splice(index, 1)
          })
        }
      })
    },
    clear() {
      this.editedItem = {
        name: '',
        descriptions: '',
        task: ''
      }
    },
    close() {
      this.dialog = false
      this.dialog_load = false

      setTimeout(() => {
        this.clear()
        this.editedIndex = -1
      }, 300)
    },
    save() {
      this.dialog_load = true
      
      if (this.editedIndex > -1) {
        var editedId = this.tasks[this.editedIndex].id
        var edited = Object.assign(this.tasks[this.editedIndex], this.editedItem)


        this.$http.patch("/api/v1/tasks/" + editedId, {
          task: {
            name: this.editedItem.name,
            descriptions: this.editedItem.descriptions,
            task: this.editedItem.task
          }
        }).then(response => {
          this.fetchTask()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'Task has been edited'
          })
        }, response => {
          this.fetchTask()
          this.dialog_load = false

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Edit Task Error',
            text: key + " " + value
          })
        })
      } else {
        this.$http.post("/api/v1/tasks", {
          task: {
            name: this.editedItem.name,
            descriptions: this.editedItem.descriptions,
            task: this.editedItem.task
          }
        }).then(response => {
          this.tasks.push(this.editedItem)
          this.fetchTask()
          this.dialog_load = false

          swal({
            type: 'success',
            title: 'Task has been added'
          })
        }, response => {
          this.fetchTask()
          this.dialog_load = false

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Add Task Error',
            text: key + " " + value
          })
        })
      }
      this.close()
    }
  }
}
</script>
