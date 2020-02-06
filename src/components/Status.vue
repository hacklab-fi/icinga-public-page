<template>
  <div class="status">
    <div>
      <!-- TODO: make the parts components and cleanup and prettier -->

      <!-- one "machine" is one component -->
      <div
        class="component"
        v-for="(item, key, index) in data"
        v-bind:key="index"
      >
        <h2 class="head" :class="item.state">
          <!-- up / down -->
          <span v-if="item.state == 'UP'" class="icon" :class="item.state"
            >✔</span
          >
          <span v-else class="icon" :class="item.state">✗</span>

          {{ key }}

          <span class="downtime" v-if="item.downtime">
            <span v-if="item.downtime.is_in_effect" class="icon now"
              >🔧 working on it:
            </span>
            <span v-else class="icon clock"
              >⏲ Scheduled
              {{ moment.unix(item.downtime.scheduled_start).fromNow() }} and
              lasting until
              {{ moment.unix(item.downtime.scheduled_end).fromNow() }}
              with comment:
            </span>
            <span class="comment">{{ item.downtime.comment }}</span>
          </span>
        </h2>

        <!-- and services inside it -->
        <div
          class="service"
          v-for="(item, key, index) in item.services"
          v-bind:key="index"
        >
          <!-- up / down -->
          <span v-if="item.state == 'OK'" class="icon" :class="item.state"
            >✔</span
          >
          <span v-else class="icon" :class="item.state">✗</span>

          {{ key }}

          <!-- downtime info for service -->
          <span v-if="item.downtime" class="downtime">
            <span v-if="item.downtime.is_in_effect" class="icon now">
              🔧 working on it:
            </span>
            <span v-else class="icon clock"
              >⏲ Scheduled
              {{ moment.unix(item.downtime.scheduled_start).fromNow() }}
              and lasting until
              {{ moment.unix(item.downtime.scheduled_end).fromNow() }}
              with comment:
            </span>
            <span class="comment">{{ item.downtime.comment }}</span>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "Status",
  data() {
    return {
      poll: null
    };
  },
  computed: {
    ...mapGetters(["data"])
  },
  methods: {
    // refresh data from the api with a simple interval
    startPoll() {
      this.poll = setInterval(() => {
        this.$store.dispatch("refereshdata");
      }, 1000 * 60 * 5); // 15 minutes
    }
  },
  async created() {
    // do a initial sync and start polling the api
    this.$store.dispatch("refereshdata");
    this.startPoll();
  },
  async beforeDestroy() {
    // clear our timer
    clearInterval(this.poll);
  }
};
</script>

<style scoped>
h2 {
  margin: 40px 0 0;
}

.icon.UP,
.icon.OK {
  color: green;
}
.icon.WARNING {
  color: rgb(223, 184, 13);
}
.icon.DOWN,
.icon.CRITICAL {
  color: red;
}
</style>
