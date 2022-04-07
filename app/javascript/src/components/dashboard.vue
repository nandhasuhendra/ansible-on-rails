<template>
  <div>
    <v-container grid-list-md>
      <v-layout row wrap text-xs-center>
        <v-flex xs12 sm2>
          <v-card dark color="primary" to="/users">
            <v-card-text class="font-weight-bold">Users</v-card-text>
            <v-divider></v-divider>
            <v-card-text>{{ dashboards.users }}</v-card-text>
          </v-card>
        </v-flex>

        <v-flex xs12 sm2>
          <v-card dark color="primary" to="/hosts">
            <v-card-text class="font-weight-bold">Hosts</v-card-text>
            <v-divider></v-divider>
            <v-card-text>{{ dashboards.hosts }}</v-card-text>
          </v-card>
        </v-flex>

        <v-flex xs12 sm2>
          <v-card dark color="primary" to="/groups">
            <v-card-text class="font-weight-bold">Groups</v-card-text>
            <v-divider></v-divider>
            <v-card-text>{{ dashboards.groups }}</v-card-text>
          </v-card>
        </v-flex>

        <v-flex xs12 sm2>
          <v-card dark color="primary" to="/credentials">
            <v-card-text class="font-weight-bold">Credentials</v-card-text>
            <v-divider></v-divider>
            <v-card-text>{{ dashboards.credentials }}</v-card-text>
          </v-card>
        </v-flex>

        <v-flex xs12 sm2>
          <v-card dark color="primary" to="/tasks">
            <v-card-text class="font-weight-bold">Tasks</v-card-text>
            <v-divider></v-divider>
            <v-card-text>{{ dashboards.tasks }}</v-card-text>
          </v-card>
        </v-flex>

        <v-flex xs12 sm2>
          <v-card dark color="primary" to="/dashboard">
            <v-card-text class="font-weight-bold">Jobs</v-card-text>
            <v-divider></v-divider>
            <v-card-text>{{ dashboards.jobs }}</v-card-text>
          </v-card>
        </v-flex>
      </v-layout>

      <v-divider></v-divider>
      <v-toolbar flat color="white">
        <v-toolbar-title>Job Lists</v-toolbar-title>
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
        <v-btn @click="dialog = true" color="primary" dark class="mb-2">New Job</v-btn>

        <v-dialog v-model="dialog" max-width="700px" persistent>
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
                input Group and Task
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
                        <v-flex xs12 sm6 md6>
                          <v-dialog
                            ref="time"
                            v-model="timePicker"
                            :return-value.sync="editedItem.timePicker"
                            persistent
                            lazy
                            full-width
                            max-width="600px"
                            min-width="290px"
                            >
                            <v-text-field
                              slot="activator"
                              v-model="editedItem.timePicker"
                              label="Time Picker"
                              prepend-icon="access_time"
                              readonly
                              @click="timePicker = true"
                              ></v-text-field>
                            <v-time-picker
                              v-if="timePicker"
                              v-model="editedItem.timePicker"
                              full-width
                              landscape
                              >
                              <v-spacer></v-spacer>
                              <v-btn flat color="primary" @click="timePicker = false">Cancel</v-btn>
                              <v-btn flat color="primary" @click="$refs.time.save(editedItem.timePicker)">OK</v-btn>
                            </v-time-picker>
                          </v-dialog>
                        </v-flex>
                        <v-flex xs12 sm6 md6>
                          <v-dialog
                            ref="date"
                            v-model="datePicker"
                            :return-value.sync="editedItem.datePicker"
                            persistent
                            lazy
                            full-width
                            max-width="600px"
                            min-width="290px"
                            >
                            <v-text-field
                              slot="activator"
                              v-model="editedItem.datePicker"
                              label="Date Picker"
                              prepend-icon="event"
                              readonly
                              @click="datePicker = true"
                              ></v-text-field>
                            <v-date-picker
                              v-if="datePicker"
                              v-model="editedItem.datePicker"
                              full-width
                              :min="minDate"
                              >
                              <v-spacer></v-spacer>
                              <v-btn flat color="primary" @click="datePicker = false">Cancel</v-btn>
                              <v-btn flat color="primary" @click="$refs.date.save(editedItem.datePicker)">OK</v-btn>
                            </v-date-picker>
                          </v-dialog>
                        </v-flex>
                      </v-layout>
                    </v-container>
                  </v-card-text>
                </v-card>
              </v-tab-item>

              <v-tab-item value="tab-2">
                <v-card flat>
                  <v-container>
                    <v-card-text>
                      <v-flex xs12 sm12>
                        <v-combobox
                          v-model="selectedTask" 
                          :items="tasks"
                          :item-text="text"
                          :key="tasks.id"
                          label="Task Name"
                          ></v-combobox>
                      </v-flex>
                    </v-card-text>

                    <v-card-text>
                      <v-flex xs12 sm12>
                        <v-combobox
                          :disabled="isFilled"
                          v-model="selectedGroup" 
                          :items="groups"
                          :item-text="text"
                          :key="groups.id"
                          label="Group Name"
                          ></v-combobox>
                      </v-flex>
                    </v-card-text>
                  </v-container>
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
        :items="jobs"
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
            <td class="text-xs-left">{{ timeFormater(props.item.scheduler) }}</td>
            <td class="text-xs-left">{{ timeFormater(props.item.deployed) }}</td>
            <td class="text-xs-left">
              <v-icon
                small
                class="mr-2"
                @click="editItem(props.item); fetchSelectedTask(props.item.task_id); fetchSelectedGroup(props.item.group_id)"
                >
                edit
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
      </v-data-table>
    </v-container>

    <div class="text-xs-center">
      <v-dialog
        persistent
        v-model="dialog_load"
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
      <v-dialog v-model="dialog_result" persistent scrollable max-width="500px">
        <v-card>
          <v-card-title
            class="headline grey lighten-2"
            primary-title
            >
            Ansible Playbook Result
          </v-card-title>

          <v-card-text style="height: 300px;">
            <v-container grid-list-md>
              <v-layout row wrap text-xs-center v-for="r in result">
                <v-flex xs12 sm12>
                  <v-card-text>
                    IP : {{ r.ip_address }}
                  </v-card-text>
                </v-flex>

                <v-flex xs3 sm3>
                  <v-alert :value="true" type="success">
                    <span class="white--text">{{ r.ok }}</span>
                  </v-alert>
                </v-flex>

                <v-flex xs3 sm3>
                  <v-alert :value="true" type="info">
                    <span class="white--text">{{ r.changed }}</span>
                  </v-alert>
                </v-flex>

                <v-flex xs3 sm3>
                  <v-alert :value="true" type="warning">
                    <span class="white--text">{{ r.unreachable }}</span>
                  </v-alert>
                </v-flex>

                <v-flex xs3 sm3>
                  <v-alert :value="true" type="error">
                    <span class="white--text">{{ r.failed }}</span>
                  </v-alert>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>

          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" flat href="/logs">Check Log</v-btn>
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
      dialog: false,
      dialog_load: false,
      dialog_result: false,
      timePicker: false,
      datePicker: false,
      minDate: "",
      search: '',
      pagination: {
        sortBy: 'deployed',
        descending: true
      },
      headers: [
        { text: 'Task Name', align: 'left', value: 'name', sortable: true },
        { text: 'Descriptions', align: 'left', value: 'descriptions', sortable: false },
        { text: 'Schedule', align: 'left', value: 'scheduler', sortable: false },
        { text: 'Last Deployed', align: 'left', value: 'deployed', sortable: false },
        { text: 'Actions', align: 'left', value: 'name', sortable: false }
      ],
      result_headers: [
        { text: 'IP Address', align: 'left', value: 'ip_address', sortable: true },
        { text: 'OK', align: 'left', value: 'ok', sortable: false },
        { text: 'Changed', align: 'left', value: 'changed', sortable: false },
        { text: 'Unreachable', align: 'left', value: 'unreachable', sortable: false },
        { text: 'Failed', align: 'left', value: 'failed', sortable: false }
      ],
      dashboards: [],
      jobs: [],
      tasks: [],
      groups: [],
      result: [],
      selectedTask: [],
      selectedGroup: [],
      editedIndex: -1,
      editedItem: {
        name: '',
        descriptions: '',
        timePicker: '',
        datePicker: '',
        deployed: '',
        task_id: ''
      }
    }
  },
  computed: {
    formTitle () {
      return this.editedIndex === -1 ? 'New Job' : 'Edit Job'
    },
    isComplete () {
      return this.editedItem.name && this.editedItem.descriptions
    },
    isFilled() {
      if (this.editedItem.group_id ) return true
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
    this.fetchJob()
    this.fetchTask()
    this.fetchGroup()
    this.fetchDashboard()
    this.fetchSelectedTask(null)
    this.fetchSelectedGroup(null)
    this.currentDate()
  },
  methods: {
    text: tasks => tasks.name,
    currentDate() {
      var today = new Date()
      var dd = today.getDate()
      var mm = today.getMonth()+1
      var yyyy = today.getFullYear()

      if(dd < 10) {
        dd='0'+dd
      }

      if(mm < 10) {
        mm='0'+mm
      }

      today = yyyy + '-' + mm + '-' + dd
      this.minDate = today
    },
    timeFormater(item) {
      if(item === null) {
        return currentTime = "Never used"
      } else {
        var currentTime = new Date(item)

        return currentTime.toLocaleString()
      }
    },
    fetchDashboard() {
      this.$http.get("/api/v1/dashboard").then(response => {
        this.dashboards = response.body.data
      })
    },
    fetchJob() {
      this.$http.get("/api/v1/jobs").then(response => {
        this.jobs = response.body.data
      })
    },
    fetchTask() {
      this.$http.get("/api/v1/tasks").then(response => {
        this.tasks = response.body.data
      })
    },
    fetchGroup() {
      this.$http.get("/api/v1/groups").then(response => {
        this.groups = response.body
      })
    },
    fetchSelectedTask(item) {
      try {
        this.selectedTask = this.tasks[item -1]
      } catch(error) {
        return true
      }
    },
    fetchSelectedGroup(item) {
      try {
        this.selectedGroup = this.groups[item -1]
      } catch(error) {
        return true
      }
    },
    editItem(item) {
      this.editedIndex = this.jobs.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },
    deleteItem(item) {
      const index = this.jobs.indexOf(item)

      swal({
        title: "Delete this job?",
        text: "Are you sure? You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete it!",
      }).then(result => {
        if (result.value) {
          this.$http.delete('/api/v1/jobs/' + item.id).then(response => {
            this.jobs.splice(index, 1)
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
        this.selectedTask = null
        this.selectedGroup = null
        this.editedIndex = -1
      }, 300)
    },
    save() {
      var dates = ''
      var task_id = ''
      var group_id = ''
      
      if (this.editedIndex > -1) {
        var editedId = this.jobs[this.editedIndex].id
        var edited = Object.assign(this.jobs[this.editedIndex], this.editedItem)

        task_id = this.selectedTask.id
        group_id = this.selectedGroup.id

        if(this.editedItem.datePicker && this.editedItem.timePicker !== undefined) {
          var input = this.editedItem.datePicker + " " + this.editedItem.timePicker
          dates = new Date(input)
        }

        this.$http.patch("/api/v1/jobs/" + editedId, {
          job: {
            name: this.editedItem.name,
            descriptions: this.editedItem.descriptions,
            task: this.editedItem.task,
            scheduler: dates,
            group_id: group_id,
            task_id: task_id
          }
        }).then(response => {
          this.fetchJob()

          swal({
            type: 'success',
            title: 'Job has been edited'
          })
        }, response => {
          this.fetchJob()

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Edit Job Error',
            text: key + " " + value
          })
        })
      } else {
        task_id = this.selectedTask.id
        group_id = this.selectedGroup.id

        if(this.editedItem.datePicker && this.editedItem.timePicker !== undefined) {
          var input = this.editedItem.datePicker + " " + this.editedItem.timePicker
          dates = new Date(input)
        }

        this.$http.post("/api/v1/jobs", {
          job: {
            name: this.editedItem.name,
            descriptions: this.editedItem.descriptions,
            task: this.editedItem.task,
            scheduler: dates,
            group_id: group_id,
            task_id: task_id
          }
        }).then(response => {
          this.jobs.push(this.editedItem)
          this.fetchJob()

          swal({
            type: 'success',
            title: 'Job has been added'
          })
        }, response => {
          this.fetchJob()

          var key = Object.keys(response.body.data)[0]
          var value = Object.values(response.body.data[key])[0]

          swal({
            type: 'error',
            title: 'Add Job Error',
            text: key + " " + value
          })
        })
      }
      this.close()
    },
    run(item) {
      this.dialog_load = true

      var itemTask = ""

      for(var task in this.tasks) {
        this.tasks[task].id === item.task_id ? itemTask = this.tasks[task].name : ""
      }

      this.$http.post("/api/v1/task", {
        ansible: { job_id: item.id , name: itemTask, file_path: 'task' }
      }).then(response => {
        this.fetchJob()
        this.result = response.body.data

        this.dialog_result = true
      })
    }
  }
}
</script>
