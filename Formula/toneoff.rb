class Toneoff < Formula
  desc "Menu bar app that turns True Tone off while external displays are connected"
  homepage "https://github.com/timu/toneoff"
  url "https://github.com/timu/toneoff/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ac2beaf8b3d41be2e501a8bd69ea2179b24e093fcb8f2aea9ad5c24f48974d7f"
  license "MIT"
  head "https://github.com/timu/toneoff.git", branch: "main"

  depends_on :macos

  def install
    system "./build.sh"
    prefix.install "build/toneoff.app"

    (bin/"toneoff").write <<~SH
      #!/bin/sh
      exec "#{opt_prefix}/toneoff.app/Contents/MacOS/toneoff" "$@"
    SH
    (bin/"toneoff").chmod 0555
  end

  service do
    run opt_prefix/"toneoff.app/Contents/MacOS/toneoff"
    keep_alive crashed: true
    process_type :interactive
    log_path var/"log/toneoff.log"
    error_log_path var/"log/toneoff.log"
  end

  def caveats
    <<~EOS
      To start toneoff once by hand:
        open "#{opt_prefix}/toneoff.app"

      To have it start at every login, use either the Homebrew service below
      or the "Launch at Login" option in its menu bar menu, but not both.
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/toneoff --help", 2)
  end
end
