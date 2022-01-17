### Run tests locally
1. Port-forward the role assignment service
```sh
kubectl port-forward -n mojaloop deploy/bof-role-assignment-service 3008
```

2. Run tests:
```sh
npm t
```

### Config
Configured via shell environment. See [config.ts](./test/config.ts).
