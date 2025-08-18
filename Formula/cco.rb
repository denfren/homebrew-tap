class Cco < Formula
  desc "cascading configuration"
  homepage "https://github.com/denfren/cco"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/cco/releases/download/v0.2.0/cco-aarch64-apple-darwin.tar.xz"
      sha256 "70f21292fa6694b946ce0adcca7179c4e68a4211af99cd1da9b511d3a762f2c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/cco/releases/download/v0.2.0/cco-x86_64-apple-darwin.tar.xz"
      sha256 "01b49849fc641e3b52fcf1801645276dcb735e70e5e0f0a7f3ce3b0b92800869"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/cco/releases/download/v0.2.0/cco-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "072b5c7a13f7d59bd86e06146144a21b6078ba504290e7589703c26b1a7a1145"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/cco/releases/download/v0.2.0/cco-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e963abdc5fe6e32630178daaba88a0e2ee2cca9ceedae92a4cd31c20c7475f1d"
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
    bin.install "cco" if OS.mac? && Hardware::CPU.arm?
    bin.install "cco" if OS.mac? && Hardware::CPU.intel?
    bin.install "cco" if OS.linux? && Hardware::CPU.arm?
    bin.install "cco" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
