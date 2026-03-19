# aqua-blade

An Aqua package for the Liferay Blade CLI.

This repo ships a small `blade` launcher and an Aqua registry entry. The launcher mirrors Liferay's local installer behavior and installs Blade into the user's home via JPM on first use.
You can pin the Blade CLI version with `BLADE_VERSION`; when set, the launcher downloads that exact version from Maven. If it is unset, the launcher uses the latest Maven release.

## Requirements

- Java (JRE/JDK) on `PATH`
- Network access to:
  - `repository-cdn.liferay.com`
  - `raw.githubusercontent.com`

## Install

```bash
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v1.0.0/aqua-installer | bash -s -- -i ~/bin/aqua
export PATH="$HOME/bin:$PATH"
export AQUA_POLICY_CONFIG="$PWD/aqua-policy.yaml"
aqua policy allow "$PWD/aqua-policy.yaml"
aqua i -l
export PATH="$HOME/.local/share/aquaproj-aqua/bin:$PATH"
blade version
```

The first `blade` run performs the JPM bootstrap if the real Blade CLI is not installed yet. After that, `blade` goes straight to the upstream CLI.

To pin a specific Blade version for one run:

```bash
BLADE_VERSION=8.0.0.202602021941 blade version
```

## Local Development

Use the repository-local registry while developing:

```bash
./test/test.sh
```

The test script generates a temporary Aqua config pinned to `v8.0.0.202602021941`. Set `BLADE_VERSION` to override the downloaded Blade CLI version.

## Registry

The package definition lives in `registry.yaml` and installs the `blade` wrapper from this repository.

For use in another repository, add this registry:

```yaml
registries:
  - name: blade
    type: github_archive
    repo_owner: kheeklab
    repo_name: aqua-blade
    ref: v8.0.0.202602021941
    path: registry.yaml

packages:
  - name: blade@v8.0.0.202602021941
    registry: blade
```

## Where Blade is installed

The real Blade binary is installed by JPM into:

- Linux: `~/jpm/bin`
- macOS: `~/Library/PackageManager/bin`

## Files

- `blade` - Aqua-installed launcher that bootstraps JPM and then execs the real Blade CLI
- `registry.yaml` - Aqua registry entry for the package
- `aqua.yaml` - Local development configuration for this repo
- `aqua-policy.yaml` - Policy file allowing the local registry during development and CI
- `test/test.sh` - Deterministic Aqua-based test harness
- `.github/workflows/ci.yml` - GitHub Actions CI pipeline

## Publishing

1. Ensure tests pass: `./test/test.sh`
2. Tag a release: `git tag -a v8.0.0.202602021941 -m "Release v8.0.0.202602021941"`
3. Push tags: `git push origin --tags`
4. Open a PR or release against the registry that consumes `registry.yaml`

## License

MIT
