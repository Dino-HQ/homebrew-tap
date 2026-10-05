class Dino < Formula
  desc "Deterministic verification layer for APIs"
  homepage "https://usedino.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.4.0/dino-darwin-arm64"
      sha256 "c6edab6f02eca645c7314628262747018b131d09bbad0c0ff341f36999010265"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.4.0/dino-darwin-x64"
      sha256 "fd92b0c0de101cf0a6695345f6229bd6bc140e2d32f5f6a52db4736e58045d13"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.4.0/dino-linux-arm64"
      sha256 "e83aad3278cb487f61e52e038ca6855ff451c5d1dae380670d33ce8c4c0b784f"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.4.0/dino-linux-x64"
      sha256 "2c9d5486a1fb5f5e3ed209fa2f166bfbcec951dc44249b2af2407110f1a18e0a"

      # The default x64 build needs AVX2; older CPUs get the baseline build.
      resource "baseline" do
        url "https://github.com/Dino-HQ/dino/releases/download/v1.4.0/dino-linux-x64-baseline"
        sha256 "84dd5d6ce3b6240984d6450b5b631d96341579372177486fa461de1885f828c8"
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
