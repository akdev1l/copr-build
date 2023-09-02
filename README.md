# copr-build: build packages in COPR without leaving GitHub Actions

This is an action that tries to make it easy to maintain COPR repositories for Fedora.
To create a new package in COPR it requires the user to go into the COPR web portal and create a new package
with the required repo configuration.

This package automates that process so that the repository can add itself to a COPR project. It also allows you
to trigger builds for the created package such that you can trigger builds from Github Actions instead of relying on
SCM monitoring from COPR.

## Usage

Example job to trigger a COPR build for a specific package:

```yaml
jobs:
  selftest:
    permissions:
      contents: read
      packages: read
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/${{ github.repository_owner }}/${{ github.event.repository.name }}/copr-build:latest
    steps:
      - name: checkout to execute local action
        uses: actions/checkout@v3
      - name: do selftest of the action
        uses: ./
        id: selftest
        env:
          COPR_API_TOKEN_CONFIG: ${{ secrets.COPR_API_TOKEN_CONFIG }}
        with:
          owner: akdev
          package-name: selftest-copr-build
          project-name: personal
          git-remote: https://github.com/akdev1l/ublue-update.git
```

### Parameters

|Parameter|Description|Required|Default|
|---------|-----------|--------|-------|
|`owner`|COPR Project Owner|No|`${{github.repository_owner}}`|
|`package-name`|COPR Package Name|No|`${{github.event.repository.name}}`|
|`project-name`|COPR Project Name|No|`${{github.repository_owner}}`|
|`git-remote`|Git Remote to build|No|`https://github.com/${{github.repository_owner}}/${{github.event.repository.name}}`|
|`committish`|Git committish to build|No|`main`|

NOTE: The package `package-name` will be created if it doesn't exist in COPR.
