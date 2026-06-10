<template>
  <div class="status">
    <!-- overall health banner -->
    <div class="overview" :class="`sev-${summary.level}`">
      <span class="overview-dot"></span>
      <span class="overview-text">{{ summary.headline }}</span>
      <span class="overview-meta" v-if="loaded">
        {{ summary.hosts }} hosts · {{ summary.total }} checks
        <template v-if="updatedAt">
          · updated {{ moment(updatedAt).format("HH:mm") }}
        </template>
      </span>
    </div>

    <!-- one card per host -->
    <div class="grid" v-if="loaded">
      <section
        class="card"
        v-for="(host, hostName) in data"
        :key="hostName"
      >
        <header class="card-head" :class="`sev-${severity(host.state)}`">
          <span class="dot"></span>
          <h2>{{ hostName }}</h2>
          <span class="badge">{{ host.state }}</span>
        </header>

        <div class="downtime" v-if="host.downtime">
          <span v-if="host.downtime.is_in_effect">🔧 working on it</span>
          <span v-else>
            ⏲ scheduled {{ moment.unix(host.downtime.scheduled_start).fromNow() }} until
            {{ moment.unix(host.downtime.scheduled_end).fromNow() }}
          </span>
          <span class="comment" v-if="host.downtime.comment"
            >— {{ host.downtime.comment }}</span
          >
        </div>

        <ul class="services">
          <li
            class="service"
            :class="`sev-${severity(svc.state)}`"
            v-for="(svc, svcName) in host.services"
            :key="svcName"
          >
            <span class="dot"></span>
            <span class="svc-name">{{ svcName }}</span>
            <span class="svc-state" v-if="severity(svc.state) !== 'ok'">{{
              svc.state
            }}</span>
            <div class="downtime" v-if="svc.downtime">
              <span v-if="svc.downtime.is_in_effect">🔧 working on it</span>
              <span v-else>
                ⏲ scheduled
                {{ moment.unix(svc.downtime.scheduled_start).fromNow() }} until
                {{ moment.unix(svc.downtime.scheduled_end).fromNow() }}
              </span>
              <span class="comment" v-if="svc.downtime.comment"
                >— {{ svc.downtime.comment }}</span
              >
            </div>
          </li>
        </ul>
      </section>
    </div>

    <p class="empty" v-else>Loading status…</p>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

const OK = ["UP", "OK"];
const WARN = ["WARNING"];
const CRIT = ["DOWN", "CRITICAL", "UNREACHABLE"];

export default {
  name: "StatusPage",
  data() {
    return {
      poll: null
    };
  },
  computed: {
    ...mapGetters(["data", "updatedAt"]),
    loaded() {
      return Object.keys(this.data).length > 0;
    },
    summary() {
      let total = 0;
      let warn = 0;
      let crit = 0;
      const hosts = Object.values(this.data);
      for (const host of hosts) {
        if (this.severity(host.state) === "crit") crit++;
        for (const svc of Object.values(host.services || {})) {
          total++;
          const sev = this.severity(svc.state);
          if (sev === "warn") warn++;
          else if (sev === "crit") crit++;
        }
      }
      const problems = warn + crit;
      const level = crit > 0 ? "crit" : warn > 0 ? "warn" : "ok";
      const headline =
        problems === 0
          ? "All systems operational"
          : `${problems} ${problems === 1 ? "check needs" : "checks need"} attention`;
      return { total, hosts: hosts.length, problems, level, headline };
    }
  },
  methods: {
    severity(state) {
      if (OK.includes(state)) return "ok";
      if (WARN.includes(state)) return "warn";
      if (CRIT.includes(state)) return "crit";
      return "unknown";
    },
    startPoll() {
      this.poll = setInterval(() => {
        this.$store.dispatch("refreshData");
      }, 1000 * 60 * 5); // 5 minutes
    }
  },
  created() {
    // do a initial sync and start polling the api
    this.$store.dispatch("refreshData");
    this.startPoll();
  },
  beforeUnmount() {
    // clear our timer
    clearInterval(this.poll);
  }
};
</script>

<style scoped>
/* overall health banner */
.overview {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  margin-bottom: 1.75rem;
  background: var(--card);
  border: 1px solid var(--border);
  border-left: 4px solid var(--sev, var(--ok));
  border-radius: var(--radius);
  box-shadow: var(--shadow);
}
.overview-dot {
  width: 13px;
  height: 13px;
  border-radius: 50%;
  background: var(--sev, var(--ok));
  box-shadow: 0 0 0 4px rgba(47, 174, 155, 0.18);
  flex: none;
}
.overview-text {
  font-size: 1.15rem;
  font-weight: 700;
}
.overview-meta {
  margin-left: auto;
  color: var(--muted);
  font-size: 0.85rem;
  text-align: right;
}

/* masonry-ish card grid */
.grid {
  columns: 330px;
  column-gap: 1.25rem;
}
.card {
  break-inside: avoid;
  margin: 0 0 1.25rem;
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  overflow: hidden;
}
.card-head {
  display: flex;
  align-items: center;
  gap: 0.55rem;
  padding: 0.8rem 1rem;
  border-bottom: 1px solid var(--border);
}
.card-head h2 {
  margin: 0;
  font-size: 1.05rem;
  font-weight: 700;
}
.card-head .badge {
  margin-left: auto;
  font-size: 0.68rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  padding: 0.15rem 0.5rem;
  border-radius: 999px;
  color: #fff;
  background: var(--sev, var(--unknown));
}

.services {
  list-style: none;
  margin: 0;
  padding: 0.3rem 0;
}
.service {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.55rem;
  padding: 0.32rem 1rem;
  font-size: 0.9rem;
}
.service:hover {
  background: var(--hover);
}
.svc-name {
  color: var(--text);
}
.svc-state {
  margin-left: auto;
  font-size: 0.68rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  color: var(--sev);
}

/* downtime note */
.downtime {
  width: 100%;
  margin: 0.1rem 0 0 1.45rem;
  font-size: 0.78rem;
  color: var(--muted);
}
.card > .downtime {
  margin: 0.5rem 1rem 0;
}
.downtime .comment {
  font-style: italic;
}

.empty {
  color: var(--muted);
  padding: 2rem 0;
  text-align: center;
}
</style>
