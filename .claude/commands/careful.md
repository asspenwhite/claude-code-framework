Toggle destructive command warnings for this session.

Sets CLAUDE_SAFETY_MODE=careful, which causes the safety-check hook to warn before:
- `rm -rf` (outside build artifacts)
- `DROP TABLE`, `DELETE FROM` without WHERE
- `git push --force`, `git reset --hard`, `git clean -f`
- `docker system prune`, `kubectl delete`

To activate, set the environment variable:
```
export CLAUDE_SAFETY_MODE=careful
```

To deactivate:
```
unset CLAUDE_SAFETY_MODE
```

See: docs/SAFETY.md for full documentation.
