cask "figstudio" do
  version "0.4.0"
  sha256 "1995ca6c471380e2739dd5fcc7ef82d33955891ad0f226217739d2946f5eb1db"

  url "https://github.com/pelvo/figstudio/releases/download/v#{version}/figstudio-v#{version}-macos-arm64.zip"
  name "figstudio"
  desc "Desktop app and CLI for Figma .fig local copies"
  homepage "https://github.com/pelvo/figstudio"

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
