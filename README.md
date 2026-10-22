# homebrew-tap

Homebrew tap for pelvo apps.

## figstudio

[figstudio](https://github.com/pelvo/figstudio), macOS Apple silicon.

```sh
brew install --cask pelvo/tap/figstudio
```

Installs `figstudio.app` and puts `figstudio-cli` and `figstudio-mcp` on the PATH.
Homebrew 6+ asks you to trust non-official taps; installing by the full name
(`pelvo/tap/figstudio`) trusts this one cask only.

The cask follows the latest GitHub release; `.github/workflows/bump.yml` checks every 6
hours. It takes the zip's digest from the release's `SHA256SUMS`, which figstudio's release
workflow uploads after all archives, and it waits while a release has none yet.

On Linux, figstudio ships static `figstudio-cli` and `figstudio-mcp` tarballs on each
release instead; this tap has no formula for them. See the
[figstudio README](https://github.com/pelvo/figstudio#try-it).
