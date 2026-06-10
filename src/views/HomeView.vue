<template>
  <div class="home">
    <StatusPage />
  </div>
</template>

<script>
// @ is an alias to /src
import StatusPage from "@/components/StatusPage.vue";

export default {
  name: "HomeView",
  components: {
    StatusPage
  }
};
</script>
