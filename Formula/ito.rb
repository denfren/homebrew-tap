class Ito < Formula
  desc "A Rhai script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.5.0/ito-aarch64-apple-darwin.tar.gz"
      sha256 "08cc9d97755e4f0e2b6f3975f4b25b1e99364bc97088c6c1e868865d241b58d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.5.0/ito-x86_64-apple-darwin.tar.gz"
      sha256 "cba15e76ede574c6b09443348fe22a2834be45c501f44f37cc6831c8b172b374"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.5.0/ito-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fff639838c987352b90ec461899e8b65b6c7a4945bae81e92145c460ffc55583"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.5.0/ito-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0a2f67d00700d0ea5d2afa52184ce821fcc23b2f62aae9c75b0eae62658ce64c"
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
