#!/bin/sh
# Rewrites Casks/figstudio.rb for a release of pelvo/figstudio (default: the latest).
# usage: scripts/bump.sh [vX.Y.Z]   needs gh, authenticated for the public repo.
set -eu
cd "$(dirname "$0")/.."
repo=pelvo/figstudio
tag=${1:-$(gh release view -R "$repo" --json tagName -q .tagName 2>/dev/null || true)}
[ -n "$tag" ] || { echo "no release yet, nothing to bump"; exit 0; }
zip="figstudio-$tag-macos-arm64.zip"
# figstudio's release workflow uploads SHA256SUMS last, after every archive. Until then the
# release is still being built: wait for the next run instead of failing this one.
sums=$(gh release download "$tag" -R "$repo" -p SHA256SUMS -O - 2>/dev/null) || {
  echo "$tag has no SHA256SUMS yet, nothing to bump"; exit 0; }
sha=$(printf '%s\n' "$sums" | awk -v f="$zip" '$2==f {print $1}')
[ -n "$sha" ] || { echo "no checksum for $zip in $tag" >&2; exit 1; }
mkdir -p Casks
cat > Casks/figstudio.rb <<RB
cask "figstudio" do
  version "${tag#v}"
  sha256 "$sha"

  url "https://github.com/$repo/releases/download/v#{version}/figstudio-v#{version}-macos-arm64.zip"
  name "figstudio"
  desc "Desktop app and CLI for Figma .fig local copies"
  homepage "https://github.com/$repo"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "figstudio.app"
  binary "#{appdir}/figstudio.app/Contents/MacOS/figstudio-cli", target: "figstudio-cli"
  binary "#{appdir}/figstudio.app/Contents/MacOS/figstudio-mcp", target: "figstudio-mcp"

  # The app is ad-hoc signed, not notarized: clear the download quarantine so it opens.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/figstudio.app"]
  end

  zap trash: "~/Library/Application Support/figstudio"
end
RB
echo "figstudio $tag $sha"
