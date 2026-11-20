class Ito < Formula
  desc "A Lua script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/denfren/ito/releases/download/v0.8.0/ito-aarch64-apple-darwin.tar.gz"
    sha256 "c6849e6dcd5f1eb34ae4cdf58caef47297ae3cd0a401ea2daa81525547229350"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.8.0/ito-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9594a6a823d4935e2d63f8ee0d62f8368f4c53db4bc2f0af296067fc042976b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.8.0/ito-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23b3420067451adf9922598fcaf15a009ff5940722a0e1cce5ef954968411e62"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ied", "ito"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ied", "ito"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ied", "ito"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
