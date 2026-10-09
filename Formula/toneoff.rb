class Toneoff < Formula
  desc "Menu bar app that turns True Tone off while external displays are connected"
  homepage "https://github.com/timu/toneoff"
  url "https://github.com/timu/toneoff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "821b17554dceaa791b1f80896338170a0838edfa8da30ad2e54cee658d45c0b9"
  license "MIT"
  head "https://github.com/timu/toneoff.git", branch: "main"

  depends_on :macos

  def install
    system "./build.sh"
    prefix.install "build/Toneoff.app"

    (bin/"toneoff").write <<~SH
      #!/bin/sh
      exec "#{opt_prefix}/Toneoff.app/Contents/MacOS/Toneoff" "$@"
    SH
    (bin/"toneoff").chmod 0555
  end

  service do
    run opt_prefix/"Toneoff.app/Contents/MacOS/Toneoff"
    keep_alive crashed: true
    process_type :interactive
    log_path var/"log/toneoff.log"
    error_log_path var/"log/toneoff.log"
  end

  def caveats
    <<~EOS
      To start Toneoff once by hand:
        open "#{opt_prefix}/Toneoff.app"

      To have it start at every login, use either the Homebrew service below
      or the "Launch at Login" option in its menu bar menu, but not both.
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/toneoff --help", 2)
  end
end
