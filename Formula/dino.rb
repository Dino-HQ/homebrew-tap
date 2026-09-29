class Dino < Formula
  desc "Deterministic verification layer for APIs"
  homepage "https://usedino.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.2/dino-darwin-arm64"
      sha256 "5c3e0eb4af9ce83e0f796673f0f5e0c2648af943a3b9ae8edafd3cbb921f6ef9"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.2/dino-darwin-x64"
      sha256 "067ad276e092ddbeaa05d5144fd250f22c6258095f5d8c9c0ae76432b9096ccf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.2/dino-linux-arm64"
      sha256 "74196ce08c69aae20155a87f9529352448a63590f5f7d0779fc9e103ed915374"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.2.2/dino-linux-x64"
      sha256 "77973ad8566482d07c988ea86491ffb0779d519b7460173d0a8b7ca743a7c017"

      # The default x64 build needs AVX2; older CPUs get the baseline build.
      resource "baseline" do
        url "https://github.com/Dino-HQ/dino/releases/download/v1.2.2/dino-linux-x64-baseline"
        sha256 "f44117d47037fb4e89a9c8d0f36e5895a040c13df612a900c6d5c6283178166a"
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
