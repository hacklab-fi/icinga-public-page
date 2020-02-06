# icinga-public-page

Simple status page that runs at https://status.hacklab.fi/

The data comes from icinga api (well a proxy script on top of icinga). See here https://github.com/OH6AD/oikopupu/blob/master/dist/icinga-public.php

# how to contribute

* clone this repo
* run yarn install
* start a new branch
* run test server
  * ```VUE_APP_ICINGA_API_URL=http://localhost:8080/demo.json yarn serve```
* make your changes
* create a pull request


# deploying new version

just run deploy.sh to get the new version running. Of course you need write access to the repo.
