<script lang="ts">
  import svelteLogo from './assets/svelte.svg'
  import viteLogo from '/vite.svg'
  import Counter from './lib/Counter.svelte'
  import Version from './lib/Version.svelte'
  import { testApi } from './services/api'

  let apiResult: string = '';
  let loading = false;

  async function handleTestApi() {
    loading = true;
    apiResult = await testApi();
    loading = false;
  }
</script>

<main>
  <div>
    <a href="https://vite.dev" target="_blank" rel="noreferrer">
      <img src={viteLogo} class="logo" alt="Vite Logo" />
    </a>
    <a href="https://svelte.dev" target="_blank" rel="noreferrer">
      <img src={svelteLogo} class="logo svelte" alt="Svelte Logo" />
    </a>
  </div>
  <h1>Vite + Svelte</h1>

  <div class="card">
    <Counter />
      <div style="margin-top:2em">
        <button on:click={handleTestApi} disabled={loading}>
          {loading ? 'Testuję...' : 'Testuj API'}
        </button>
        {#if apiResult}
          <div class="api-result">Wynik API: {apiResult}</div>
        {/if}
      </div>
  </div>

  <p>
    Check out <a href="https://github.com/sveltejs/kit#readme" target="_blank" rel="noreferrer">SvelteKit</a>, the official Svelte app framework powered by Vite!
  </p>

  <p class="read-the-docs">
    Click on the Vite and Svelte logos to learn more
  </p>

  <footer>
    <Version />
  </footer>
</main>

<style>
  .logo {
    height: 6em;
    padding: 1.5em;
    will-change: filter;
    transition: filter 300ms;
  }
  .logo:hover {
    filter: drop-shadow(0 0 2em #646cffaa);
  }
  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00aa);
  }
  .read-the-docs {
    color: #888;
  }

  .api-result {
    margin-top: 1em;
    padding: 0.5em 1em;
    background: #f6f6f6;
    border-radius: 6px;
    font-size: 1em;
    color: #333;
  }
</style>
