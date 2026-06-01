class Ito < Formula
  desc "A Rhai script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.1.1/ito-aarch64-apple-darwin.tar.xz"
      sha256 "58027deb8fe82ef3ebe4c73e12287ee2afdb7748b171698a7f77a1d0b2c5b9d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.1.1/ito-x86_64-apple-darwin.tar.xz"
      sha256 "96739f31c0a2f1c3a0a092f0bd43f8d89ac2c9936945f2ba392ff08ba3209026"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.1.1/ito-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf55c2a812b8ff11a2bf91a8430963bc625e3f966c43655d1e1fbef77d64dadb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.1.1/ito-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c15ac28c7870cddf5c0531878b02acf2e8a5a6362436d5c224ccd19ee981fda"
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
