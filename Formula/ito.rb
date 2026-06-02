class Ito < Formula
  desc "A Rhai script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.1.2/ito-aarch64-apple-darwin.tar.xz"
      sha256 "ec74754bfd14e35d60ea6feb47ff4ed01a90200f6c3b280b8e3022a9c3b7317e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.1.2/ito-x86_64-apple-darwin.tar.xz"
      sha256 "88bd0340486624604b5d7dcb1564140d81b9059aa96a4caccea2f072fcaf3f2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.1.2/ito-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b4e87ff1ec05b6da06de33a74fdb1535e6e2c62b129ee60672446f16217a1271"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.1.2/ito-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6fa30f47ff3918bfe0556df1156bf35afaba089daf39647a69fdfa053880316a"
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
