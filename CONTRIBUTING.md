# Contributing to chef-cookbooks

## Development setup

```
bundle install
bundle exec rake lint
bundle exec rake spec
```

## Running tests for a single cookbook

```
bundle exec rake cookbook:httpd:lint
bundle exec rake cookbook:httpd:spec
bundle exec rake cookbook:httpd:kitchen
```

## Requirements

- Ruby 3.1 (matches Chef Infra Client 18)
- Chef 18 or later for local cookbook development
- Docker (for Test Kitchen with the dokken driver)

## Conventions

- One Custom Resource per file in `cookbooks/<name>/resources/`.
- InSpec integration tests in `cookbooks/<name>/test/integration/<suite>/`.
- ChefSpec unit tests in `cookbooks/<name>/spec/unit/`.
- Cookstyle (`bundle exec rake lint`) must pass before merge.
- No `providers/` directory; all Custom Resources live under `resources/`.
- No Berksfile; cookbook dependencies are declared in `metadata.rb` and resolved via the monorepo Policyfiles or direct cookbook paths.

## Commit style

- Conventional Commits format (`feat(httpd): ...`, `fix(nginx): ...`).
- DCO sign-off required (`git commit -s`).
- One logical change per commit.
