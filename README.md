### ansible deployment of a parity PoA network

This playbook will deploy 3 nodes, running in docker, on a remote host after pulling the latest parity-ethereum source from gitlab and building a new image on top of rust:1.29.1-slim-stretch.
Tested on a fresh Google Cloud debian stretch box; only requirements are having your pubkey on the system, allowing ssh traffic and unfirewalling port 3001 (for the ethstats dashboard).
-------------
You can run the playbook like this:
`ansible-playbook site.yml -f 10 -u`

It comprises of two roles, "common" and "authority". The common role takes care of docker/other packages installation and the authority role handles the setup of the authority network. After the playbook runs, the ethstats dashboard should be accessible at your.ip:3001. This is admittedly of limited use for a PoA network, but there's a [recent fork of the project](https://github.com/eosclab/eth-netstats) that has PoA features on its roadmap, so that's something to keep an eye on.


