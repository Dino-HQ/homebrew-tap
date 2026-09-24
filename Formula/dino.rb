class Dino < Formula
  desc "Deterministic verification layer for APIs"
  homepage "https://usedino.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.5/dino-darwin-arm64"
      sha256 "9d2733e0845ae219c05dd412fdb0e17e47bb117985655ddf23d4e241cd1e08d1"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.5/dino-darwin-x64"
      sha256 "51d72299f41748ec50bc2a79d3723a2127ad689df0b11e2d7571b1ea41c2e819"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.5/dino-linux-arm64"
      sha256 "9c67ac9c1842e7e32f1804f5c9ddf7782dd28960268344b4f379d36e135e8b30"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.5/dino-linux-x64"
      sha256 "4c459ef32cdf41210c17090c85f0e6f2bd56653ca2ee0f9f68f7901ec0f5f6e6"

      # The default x64 build needs AVX2; older CPUs get the baseline build.
      resource "baseline" do
        url "https://github.com/Dino-HQ/dino/releases/download/v1.1.5/dino-linux-x64-baseline"
        sha256 "7d5bf5f761f4c1de7046c296660ac1122370e679684713e6fc40c8d9f4217884"
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
