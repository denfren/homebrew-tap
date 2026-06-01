class Ito < Formula
  desc "A Rhai script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.1.0/ito-aarch64-apple-darwin.tar.xz"
      sha256 "384a2c5043b9e8775a911dec81394ca335636b70da003d61fd5b009b2e526553"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.1.0/ito-x86_64-apple-darwin.tar.xz"
      sha256 "e66e8b012c7c4090023ada28cc217acc2a2b93bfe9c1adc7fb18354f83860273"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.1.0/ito-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fbadc233fdda5c0caddc4f7fa18c0c9f9f5ad1eb5d68912f248be94589d3266c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.1.0/ito-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7978ce148ee6f232ab0537fa6e62c46236aaa134b12ce264da260e88e361ef81"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "ito" if OS.mac? && Hardware::CPU.arm?
    bin.install "ito" if OS.mac? && Hardware::CPU.intel?
    bin.install "ito" if OS.linux? && Hardware::CPU.arm?
    bin.install "ito" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
