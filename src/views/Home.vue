<template>
  <div class="home">
    <Status />
  </div>
</template>

<script>
// @ is an alias to /src
import Status from "@/components/Status.vue";

export default {
  name: "home",
  components: {
    Status
  }
};
</script>
