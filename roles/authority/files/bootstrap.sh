#!/bin/bash
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node0", "node0"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user", "user"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node2", "node2"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542
echo 'engine_signer = "0x00bd138abd70e2f00903268f3db08f2d25677c9e"' >> config/node0.toml
echo 'engine_signer = "0x00aa39d30f0d20ff03a22ccfc30b7efbfca597c2"' >> config/node1.toml
echo 'engine_signer = "0x002e28950558fbede1a9675cb113f0bd20912019"' >> config/node2.toml
for node in $(docker ps -f "name=node"); do
    docker container restart $node
done

ENODE_0=$(curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540 | jq '.result')
ENODE_1=$(curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541 | jq '.result')
ENODE_2=$(curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542 | jq '.result')
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["'$ENODE_0'"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["'$ENODE_2'"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8541
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["'$ENODE_0'"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["'$ENODE_1'"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8542
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["'$ENODE_1'"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["'$ENODE_2'"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
