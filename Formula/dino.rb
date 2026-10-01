class Dino < Formula
  desc "Deterministic verification layer for APIs"
  homepage "https://usedino.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.3.0/dino-darwin-arm64"
      sha256 "05a99f7eec6285a0885f5ebcaf61dc0bb46eefa614064c7c30672c0d3cab0188"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.3.0/dino-darwin-x64"
      sha256 "5db38276aa96ddcd3875e3e204d94495c15789e7a1d89359c44842c93a342217"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.3.0/dino-linux-arm64"
      sha256 "323dd916deab8a150ed9f56c62188b56add0fd68e2414065b69618c6621c5cdb"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.3.0/dino-linux-x64"
      sha256 "4d4113b2cc6b330b73607b22dcfa6f64c4c48833ea362f3ef8df1aeacdb32c57"

      # The default x64 build needs AVX2; older CPUs get the baseline build.
      resource "baseline" do
        url "https://github.com/Dino-HQ/dino/releases/download/v1.3.0/dino-linux-x64-baseline"
        sha256 "c5f46c7aac7b44e6678bf9d6c0251f64a646ee23969ebbe54bb4b531a0f36560"
      end
    end
  end

  def install
    if OS.linux? && Hardware::CPU.intel? && !Hardware::CPU.avx2?
      resource("baseline").stage { bin.install Dir["dino-*"].first => "dino" }
    else
      bin.install Dir["dino-*"].first => "dino"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dino --version")
  end
end
