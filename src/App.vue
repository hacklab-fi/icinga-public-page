<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Status</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view />
  </div>
</template>

<style>
#app {
  max-width: 1200px;
  margin: 0 auto;
}
</style>
