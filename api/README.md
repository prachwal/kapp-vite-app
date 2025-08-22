api
=====

TypeScript version of the API used for Vercel. Build then run the Vercel-compatible handler locally.

Build
-----

Run from project root:

```bash
npm run api:v2:build
```

Start (after build)
--------------------

```bash
npm run api:v2:start
```

Test
----

Then curl:

```bash
curl http://localhost:5173/api/health
curl http://localhost:5173/api/hello
```
