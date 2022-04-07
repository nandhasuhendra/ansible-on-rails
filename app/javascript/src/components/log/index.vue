<template>
  <div>
    <v-tabs
      centered
      fixed-tabs
      color="primary"
      dark
      slider-color="white"
      >
      <v-tab href="#tab-1">
        Rails Logs
      </v-tab>

      <v-tab href="#tab-2">
        SSH Logs
      </v-tab>

      <v-tab href="#tab-3">
        Ansible Logs
      </v-tab>

      <v-tab-item value="tab-1">
        <v-card flat>
          <v-card-text>
            <editor v-model="rails" @init="editorInit"></editor>
          </v-card-text>
        </v-card>
      </v-tab-item>

      <v-tab-item value="tab-2">
        <v-card flat>
          <v-card-text>
            <editor v-model="ssh" @init="editorInit"></editor>
          </v-card-text>
        </v-card>
      </v-tab-item>

      <v-tab-item value="tab-3">
        <v-card flat>
          <v-card-text>
            <editor v-model="ansible" @init="editorInit"></editor>
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs>
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
        rails: "",
        ssh: "",
        ansible: ""
      }
    },
    created: function() {
      this.fetchRails()
      this.fetchSSH()
      this.fetchAnsible()
    },
    methods: {
      editorInit: function (editor) {
        require('brace/ext/language_tools')
        require('brace/theme/chrome')

        editor.setOption("readOnly", true)
	editor.setOption("minLines", 2)
	editor.setOption("maxLines", 15)
	editor.setOption("fontSize", "12pt")
        editor.setOption("highlightActiveLine", true)
	editor.setOption("AutoScrollEditorIntoView", true) 

	editor.renderer.showPrintMargin(true)
      },
      fetchRails() {
        this.$http.get("/api/v1/rails").then(response => {
          var value = response.body.data.map(function(val) {
            return val.replace(/[\r\n]+/g, '')
          })

          this.rails = value.join("\n")
        })
      },
      fetchSSH() {
        this.$http.get("/api/v1/ssh").then(response => {
          var value = response.body.data.map(function(val) {
            return val.replace(/[\r\n]+/g, '')
          })

          this.ssh = value.join("\n")
        })
      },
      fetchAnsible() {
        this.$http.get("/api/v1/ansible").then(response => {
          var value = response.body.data.map(function(val) {
            return val.replace(/[\r\n]+/g, '')
          })

          this.ansible = value.join("\n")
        })
      }
    }
  }
</script>
