# Chef Cookbooks

Monorepo of Chef cookbooks previously maintained as individual repositories.

## Cookbooks

| Cookbook | Path | Description |
|----------|------|-------------|
| hbase | `cookbooks/hbase/` | Apache HBase distributed database |
| httpd | `cookbooks/httpd/` | Apache HTTP Server |
| net-snmp | `cookbooks/net-snmp/` | Net-SNMP daemon and tools |
| nginx | `cookbooks/nginx/` | Nginx web server |
| r-language | `cookbooks/r-language/` | R statistical language runtime |
| snmp | `cookbooks/snmp/` | SNMP base configuration |
| tcp-wrappers | `cookbooks/tcp-wrappers/` | hosts.allow / hosts.deny |
| zabbix | `cookbooks/zabbix/` | Zabbix monitoring agent/server |

## Examples and Templates

- `examples/vagrant/` — Vagrant integration example
- `cookbook-template/` — Template for creating new cookbooks

## History

Each cookbook retains its full git history, imported via `git filter-repo` with paths rewritten into `cookbooks/<name>/`. The original individual repos have been archived.

## Development

Every cookbook shares the same testing and release pipeline defined in `.github/workflows/` and a single `Berksfile` at the repo root.

```
bundle install
rake spec          # ChefSpec across all cookbooks
rake kitchen       # Test Kitchen (per-cookbook)
rake foodcritic    # Lint all cookbooks
```

## License

See `LICENSE` in each cookbook directory.
