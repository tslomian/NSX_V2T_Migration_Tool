# vcd-v2t

NSX-V to NSX-T migration tool for VMware Cloud Director.

## Changelog

The changes below are included in **TS_MT_v1.4.3**.

### Bridge only selected networks

Add the optional `BridgedNetworks[]` list to a source Org VDC in the input file (see `src/sampleUserInput.yml`):

```yaml
BridgedNetworks:
  - Network1Name
  - Network2Name
```

| Value | Result |
|---|---|
| not set | all non-direct networks are bridged (as before) |
| empty list | no network is bridged |
| list of names | only the listed networks are bridged |

Pre-check verifies that every listed network exists and is not a direct network.

### Skip the bridging connectivity check

```
python vcdNSXMigrator.py --filepath <input.yml> --skipVerifyBridgeConn
```

Bridging is still configured, only the connectivity verification is skipped. Not available with `--cleanup`, `--preCheck`, `--rollback` or `--v2tAssessment`.

### More tolerant connectivity check

The check now waits 30 s before starting and retries every 30 s for up to 180 s before failing.

### Roll back only the bridging

```
python vcdNSXMigrator.py --filepath <input.yml> --rollback --execute bridging
```

Removes only the NSX-T bridging and leaves the rest of the migration in place. Run a plain `--rollback` afterwards to roll back the remaining stages. Use it when bridging was the last stage applied. `bridging` is the only value allowed with `--rollback --execute`.

### Better bridging logs

- The bridged networks are listed in the bridging and rollback messages.
- Every bridging object (transport zone, uplink profile, bridge endpoint profile, edge node changes, segment attachments) is logged when its creation or removal starts and again when it succeeds.
- The end-state summary has a new `Bridged Networks` row under `Org VDC Networks`.
- Rollback and cleanup act on the networks that were actually bridged, even if `BridgedNetworks[]` was changed afterwards.

