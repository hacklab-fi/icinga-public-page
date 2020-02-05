<template>
  <div class="hello">
    <h1>{{ data }}</h1>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "HelloWorld",
  computed: {
    ...mapGetters(["data"])
  },
  beforeCreate() {
    this.$store.dispatch("refereshdata");
  }
};
</script>

<style scoped>
h3 {
  margin: 40px 0 0;
}
</style>
