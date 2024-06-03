# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv
test-contract :; forge test --match-contract ${filter} -vvv

get-proxy-impl :;
	@cast implementation ${address} --rpc-url ${rpc}

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@npx prettier ${before} ${after} --write
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md

download-pool-etherscan :;
	cast etherscan-source --chain 1 -d etherscan/v3PoolEthereum 0xf1cd4193bbc1ad4a23e833170f49d60f3d35a621
	cast etherscan-source --chain 137 -d etherscan/v3PoolPolygon 0xb77fc84a549ecc0b410d6fa15159c2df207545a3
	cast etherscan-source --chain 43114 -d etherscan/v3PoolAvalanche 0xcf85ff1c37c594a10195f7a9ab85cbb0a03f69de
	cast etherscan-source --chain 10 -d etherscan/v3PoolOptimism 0x764594f8e9757ede877b75716f8077162b251460
	cast etherscan-source --chain 42161 -d etherscan/v3PoolArbitrum 0xbcb167bdcf14a8f791d6f4a6edd964aed2f8813b
	cast etherscan-source --chain 100 -d etherscan/v3PoolGnosis 0xb1532b76d054c9f9e61b25c4d91f69b4133e4671
	cast etherscan-source --chain 8453 -d etherscan/v3PoolBase 0xdc9bafe7b1df4f7af863fcada6827e488d06bb20
	cast etherscan-source --chain 1088 -d etherscan/v3PoolMetis 0x8adb6916bc161d7e3d46286adad3c77eef84eb5d

diff-mainnet-local :;
	mkdir -p diffs/MAINNET_FACTORY_LOCAL
	npx tsx ./diff.ts MAINNET FACTORY_LOCAL

# Deploy
deploy-ledger :; forge script ${contract} --rpc-url ${chain} $(if ${dry},--sender 0x25F2226B597E8F9514B3F68F00f494cF4f286491 -vvvv, --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow --broadcast)
deploy-pk :; forge script ${contract} --rpc-url ${chain} $(if ${dry},--sender 0x25F2226B597E8F9514B3F68F00f494cF4f286491 -vvvv, --private-key ${PRIVATE_KEY} --verify -vvvv --slow --broadcast)
