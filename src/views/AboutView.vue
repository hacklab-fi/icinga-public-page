<template>
  <div class="about card">
    <h1>About this status page</h1>
    <p>
      A simple public status page for the
      <a href="https://hacklab.fi/">hacklab.fi</a> infrastructure. It polls our
      Icinga monitoring (via a small public proxy) and shows the live state of
      each host and its service checks.
    </p>
    <p>
      Status refreshes automatically every few minutes. Green means the check is
      OK; amber and red flag checks that need attention.
    </p>
    <p>
      <a href="https://github.com/hacklab-fi/icinga-public-page">Source on GitHub</a>
    </p>
  </div>
</template>

<style scoped>
.about {
  max-width: 640px;
  padding: 1.5rem 1.75rem;
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
}
.about h1 {
  margin-top: 0;
  font-size: 1.4rem;
}
.about p {
  color: var(--text);
}
</style>
