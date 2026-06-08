class Ito < Formula
  desc "A Rhai script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.3.0/ito-aarch64-apple-darwin.tar.gz"
      sha256 "358d23610a0dc32615781efabf2838dc8d7e84a5a9779a413835e228e565d3a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.3.0/ito-x86_64-apple-darwin.tar.gz"
      sha256 "e8249591c0297f758a3e92e7a85a406a899efbb1cb10f5c979867accd62e8e51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.3.0/ito-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d0b680da48ef4dbab94e5649984a3d94b46c37e63cc1388af032b9625abe717"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.3.0/ito-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "71d0d8565ff6a3408007a112952d57930c74a492aa2a7cd6f1a05092e79eb238"
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
