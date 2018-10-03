#!/bin/bash
# Bootstrap script to hook Parity PoA nodes together
# based on https://wiki.parity.io/Demo-PoA-tutorial.html

# init our authorities and a user
# to scale, the phrases to initialize can be a list to iterate over
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node0", "node0"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user", "user"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node2", "node2"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542

# we know these values already as we've defined the phrases, so we can add them to our configs
if ! grep -q "engine_signer" /code/parity-ethereum/config/node*; then
    echo 'engine_signer = "0x00bd138abd70e2f00903268f3db08f2d25677c9e"' >> /code/parity-ethereum/config/node0.toml
    echo 'engine_signer = "0x00aa39d30f0d20ff03a22ccfc30b7efbfca597c2"' >> /code/parity-ethereum/config/node1.toml
    echo 'engine_signer = "0x002e28950558fbede1a9675cb113f0bd20912019"' >> /code/parity-ethereum/config/node2.toml
fi

# restart the docker containers with the new configs
for node in $(docker ps -f "name=node" -q); do
    docker container restart $node
done

# give the containers time to come up properly
sleep 15

# let the containers know everyone else exists by distributing their enodes
ENODE_0=$(curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540 | jq '.result')
ENODE_1=$(curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541 | jq '.result')
ENODE_2=$(curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542 | jq '.result')
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":['"$ENODE_2"'],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":['"$ENODE_2"'],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":['"$ENODE_0"'],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":['"$ENODE_1"'],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":['"$ENODE_1"'],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":['"$ENODE_2"'],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
