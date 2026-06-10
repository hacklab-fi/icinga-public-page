# icinga-public-page

Simple status page that runs at https://status.hacklab.fi/

The data comes from the icinga api (well, a proxy script on top of icinga). See
https://github.com/OH6AD/oikopupu/blob/master/dist/icinga-public.php

Built with Vue 3 + Vite. The data source is configured via `VITE_ICINGA_API_URL`
(see `.env` for the committed default).

## how to contribute

* clone this repo
* `npm install`
* start a new branch
* run the dev server: `npm run dev` (uses the data source in `.env`)
  * to point at something else: `VITE_ICINGA_API_URL=http://localhost:8080/demo.json npm run dev`
* make your changes (`npm run lint` to auto-format/fix)
* open a pull request — CI will lint + build it

## sandboxed builds (recommended)

To run install/build inside a disposable, locked-down Docker container use:

```sh
docker/sandbox.sh build-image   # once
docker/sandbox.sh install       # install deps (network on)
docker/sandbox.sh build         # build offline
docker/sandbox.sh dev           # dev server on http://127.0.0.1:5173
```

## deploying

Deployment is automatic: pushing to the default branch triggers
`.github/workflows/deploy.yml`, which builds the site and publishes it to GitHub Pages.
