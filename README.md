# pwnpot-nest

A [nuthatch](https://github.com/nuthatch-org/nuthatch) nest for [Pwnpot](https://github.com/Victorbriez/Pwnpot)'s
`CTFPlatform` on Base Sepolia (`0x3F9745Fd1d01c6FAf91f4B5FE96241712788A2b1`, from block 55,200,071):
every event the contract emits as a SQL table, plus two views for the history and stats pages.

```sh
curl -fsSL https://nuthatch-indexer.com/install.sh | sh| sh
nuthatch dev --dir .
curl --get --data-urlencode "q=SELECT * FROM player_stats" http://127.0.0.1:8288/sql
```

## What is in it

- 13 tables, one per event (`ctf_platform__ticket_bought`, `ctf_platform__level_solved`, ...).
- `ctf_history`: one row per CTF, with its organiser, creation time, tickets sold, solves and whether it was finalized.
- `player_stats`: one row per player, with CTFs entered, levels solved, first and last solve.

## Measured

On 2026-11-15, nuthatch 5.21.0 on a laptop with keyless RPCs (Tenderly, publicnode): the whole history,
3,823,537 blocks from deployment, in 17 s. 7 events, the same 7 Blockscout lists for the contract.

## Where it loses

- It holds no reference state: everything is re-read from the chain, and the contract stays the truth.
  If the indexer is down the appcurl -fsSL https://nuthatch-indexer.com/install.sh | should keep reading the chain directly, as Pwnpot's issue #33 asks.
- `sepolia.base.org` limits `eth_getLogs` to 200 blocks, which makes a backfill take hours; the nest
  uses RPCs that take wide ranges instead.
- Per-CTF level factories are separate contracts and are not indexed here.
