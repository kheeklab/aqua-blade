# aqua-blade

An Aqua package for the Liferay Blade CLI.

This repo ships a small `blade` wrapper and an Aqua registry entry. The wrapper mirrors Liferay's local installer behavior and installs Blade into the user's home via JPM (no system-wide install).

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
aqua i -l
export PATH="$HOME/.local/share/aquaproj-aqua/bin:$PATH"
blade version
```

## Local Development

Use the repository-local registry while developing:

```bash
./test/test.sh
```

The test script generates a temporary Aqua config pinned to `v1.0.0`, so it exercises the release artifact path.

## Registry

The package definition lives in `registry.yaml` and installs the `blade` wrapper from this repository.

For use in another repository, add this registry:

```yaml
registries:
  - name: blade
    type: github_content
    repo_owner: kheeklab
    repo_name: aqua-blade
    ref: v1.0.0
    path: registry.yaml

packages:
  - name: blade@v1.0.0
    registry: blade
```

## Where Blade is installed

The Blade binary is installed by JPM into:

- Linux: `~/jpm/bin`
- macOS: `~/Library/PackageManager/bin`

## Files

- `blade` - Aqua-installed wrapper that bootstraps JPM and Blade
- `registry.yaml` - Aqua registry entry for the package
- `aqua.yaml` - Local development configuration for this repo
- `aqua-policy.yaml` - Policy file allowing the local registry during development and CI
- `test/test.sh` - Deterministic Aqua-based test harness
- `.github/workflows/ci.yml` - GitHub Actions CI pipeline

## Publishing

1. Ensure tests pass: `./test/test.sh`
2. Tag a release: `git tag -a v1.0.0 -m "Release v1.0.0"`
3. Push tags: `git push origin --tags`
4. Open a PR or release against the registry that consumes `registry.yaml`

## License

MIT
