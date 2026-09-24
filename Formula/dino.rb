class Dino < Formula
  desc "Deterministic verification layer for APIs"
  homepage "https://usedino.dev"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.3/dino-darwin-arm64"
      sha256 "52bd29fa46d3bb3af7c636b9ed52624d8da059f7cff87b61a5cab1ddac88048a"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.3/dino-darwin-x64"
      sha256 "03210c344a32f8a01ec62b8df1fe4f545245d0e6a8709d00982895347362027d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.3/dino-linux-arm64"
      sha256 "7e2016b591c15699487fce7e60f392e8e358964f707bebf27b2da58c5665df79"
    end
    on_intel do
      url "https://github.com/Dino-HQ/dino/releases/download/v1.1.3/dino-linux-x64"
      sha256 "2992ee8ed22c2fb071d22617fdb1800f096a1f3a22c8040db7f4567a67c79dbd"

      # The default x64 build needs AVX2; older CPUs get the baseline build.
      resource "baseline" do
        url "https://github.com/Dino-HQ/dino/releases/download/v1.1.3/dino-linux-x64-baseline"
        sha256 "9e352a74e50b77006dade716978ab0e0c4de2710711ce1447da4fd2d9f0485e9"
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
