# install dependencies, if needed
sudo apt install curl tmux jq lz4 unzip -y

# stop node
sudo systemctl stop story story-geth

# backup priv_validator_state.json
cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup

# remove old data and unpack Story snapshot
rm -rf $HOME/.story/story/data
curl https://server-3.itrocket.net/testnet/story/story_2024-10-06_1203056_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.story/story

# restore priv_validator_state.json
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

# delete geth data and unpack Geth snapshot
rm -rf $HOME/.story/geth/iliad/geth/chaindata
curl https://server-3.itrocket.net/testnet/story/geth_story_2024-10-06_1203056_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.story/geth/iliad/geth

# restart node and check logs
sudo systemctl restart story story-geth
sudo journalctl -u story-geth -u story -f
