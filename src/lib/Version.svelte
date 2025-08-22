<script lang="ts" context="module">
  // Vite injects __APP_VERSION__ via define in vite.config.ts
  declare const __APP_VERSION__: string;
</script>

<script lang="ts">
  const version = typeof __APP_VERSION__ !== 'undefined' ? __APP_VERSION__ : 'dev';
</script>

<style>
  .version {
    font-size: 0.9rem;
    color: #666;
    margin-top: 1rem;
  }
</style>

<div class="version">v{version}</div>
