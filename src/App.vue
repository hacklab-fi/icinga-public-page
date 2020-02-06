<template>
  <div id="app">
    <router-view />
    <div id="nav">
      <router-link to="/">Status</router-link> |
      <router-link to="/about">About</router-link>
    </div>
  </div>
</template>

<style>
#app {
  max-width: 1200px;
  margin: 0 auto;
}
#nav {
  margin-top: 1em;
  text-align: center;
}
</style>
