class Ito < Formula
  desc "A Rhai script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.2.0/ito-aarch64-apple-darwin.tar.xz"
      sha256 "a7028bb66e30a02c5e7dd6752d6c5e0691cd27f4333324e1460556dbbba9d50a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.2.0/ito-x86_64-apple-darwin.tar.xz"
      sha256 "64237c98dc8f3daf27a48396491c2ee14e2f0def8d587f68891f460d77eeaefb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.2.0/ito-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ddb3cd91314e38494a17c7858de1968ab1d6f5deab6001329bbb9871804ff0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.2.0/ito-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84ba0f4561ea6dbbb70ec9fb7e50d19d21e6b491f9fbe4e6aa5fd0fe1be7c432"
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
