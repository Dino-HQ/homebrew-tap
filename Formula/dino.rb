class Dino < Formula
  desc "Deterministic verification layer for APIs"
  homepage "https://usedino.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.1/dino-darwin-arm64"
      sha256 "ab33fcda7952d02a285c707547c9666b9324e1bc5d904f776dcce401c5e50d0e"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.1/dino-darwin-x64"
      sha256 "74b406007e9d27f22770294019cb4b3bc8e79f0fd1e888d6659214fce522fe49"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.1/dino-linux-arm64"
      sha256 "47e280063016634e79bb96ad86e276736eee449eecd01e2d9d20b682ca800f7d"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.1/dino-linux-x64"
      sha256 "9451aa3000b2890565ecd714210edce2ac1c0c42565e59a6e0cbcb0934746da4"

      # The default x64 build needs AVX2; older CPUs get the baseline build.
      resource "baseline" do
        url "https://github.com/Dino-HQ/dino/releases/download/v1.2.1/dino-linux-x64-baseline"
        sha256 "70026163b46cf4099d6237409a8b26f8254ee9281394cb067ec366dc27043183"
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
