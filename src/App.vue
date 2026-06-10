<template>
  <div id="app">
    <header class="site-header">
      <div class="bar">
        <a class="brand" href="https://hacklab.fi/">
          <img src="@/assets/hacklab_logo.png" alt="hacklab.fi" />
          <span class="brand-sub">status</span>
        </a>
        <nav>
          <router-link to="/">Status</router-link>
          <router-link to="/about">About</router-link>
          <button
            class="theme-toggle"
            type="button"
            @click="toggleTheme"
            :aria-label="theme === 'dark' ? 'Switch to light theme' : 'Switch to dark theme'"
          >
            <!-- sun when dark (click → light), moon when light (click → dark) -->
            <svg
              v-if="theme === 'dark'"
              viewBox="0 0 24 24"
              width="18"
              height="18"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <circle cx="12" cy="12" r="4" />
              <path
                d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"
              />
            </svg>
            <svg
              v-else
              viewBox="0 0 24 24"
              width="18"
              height="18"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
            </svg>
          </button>
        </nav>
      </div>
    </header>

    <main class="container">
      <router-view />
    </main>

    <footer class="site-footer">
      <span>Monitored with Icinga</span>
      <span class="sep">·</span>
      <a href="https://github.com/hacklab-fi/icinga-public-page">Source on GitHub</a>
    </footer>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    // index.html's inline script already set data-theme from storage/OS preference.
    return { theme: document.documentElement.dataset.theme || "light" };
  },
  methods: {
    toggleTheme() {
      this.theme = this.theme === "dark" ? "light" : "dark";
      document.documentElement.dataset.theme = this.theme;
      localStorage.setItem("theme", this.theme);
    }
  }
};
</script>

<style>
.site-header {
  background: var(--brand);
}
.site-header .bar {
  max-width: 1100px;
  margin: 0 auto;
  padding: 0.75rem 1.25rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}
.brand {
  display: flex;
  align-items: baseline;
  gap: 0.6rem;
  text-decoration: none;
}
.brand:hover {
  text-decoration: none;
}
.brand img {
  height: 34px;
  width: auto;
  display: block;
}
.brand-sub {
  color: var(--brand-tint);
  font-weight: 600;
  font-size: 1.1rem;
  letter-spacing: 0.02em;
}
.site-header nav {
  margin-left: auto;
  display: flex;
  gap: 0.35rem;
}
.site-header nav a {
  color: var(--brand-tint);
  font-weight: 600;
  font-size: 0.9rem;
  padding: 0.4rem 0.8rem;
  border-radius: 999px;
}
.site-header nav a:hover {
  text-decoration: none;
  background: rgba(255, 255, 255, 0.12);
}
.site-header nav a.router-link-exact-active {
  background: var(--brand-accent);
  color: var(--brand);
}
.theme-toggle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  margin-left: 0.15rem;
  padding: 0;
  border: none;
  border-radius: 999px;
  background: transparent;
  color: var(--brand-tint);
  cursor: pointer;
}
.theme-toggle:hover {
  background: rgba(255, 255, 255, 0.12);
}

.container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 1.75rem 1.25rem 2.5rem;
}

.site-footer {
  max-width: 1100px;
  margin: 0 auto;
  padding: 1.5rem 1.25rem 2.5rem;
  color: var(--muted);
  font-size: 0.85rem;
  text-align: center;
}
.site-footer .sep {
  margin: 0 0.5rem;
}
</style>
