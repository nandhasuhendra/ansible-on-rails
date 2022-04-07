<template functional>
  <v-container grid-list-md>
    <v-layout row wrap>
      <v-flex xs12>
        <v-card>
          <v-card-title class="red darken-3 white--text subheading" primary-title>
            <span class="title">Oops!</span>
          </v-card-title>
          <v-card-text>
            <h1>404, page not found :-(</h1>
          </v-card-text>
          <v-card-actions>
            <v-btn flat class="red darken-3 white--text" href="javascript:history.go(-1)">Back</v-btn>
          </v-card-actions>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>
