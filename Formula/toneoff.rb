class Toneoff < Formula
  desc "Menu bar app that turns True Tone off while external displays are connected"
  homepage "https://github.com/timu/toneoff"
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
      To start Toneoff now and at every login:
        brew services start toneoff

      Or start it once by hand:
        open "#{opt_prefix}/Toneoff.app"

      Use one or the other. If you start it from the Homebrew service, leave
      "Launch at Login" in its menu unticked.
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/toneoff --help", 2)
  end
end
