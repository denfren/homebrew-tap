class Ito < Formula
  desc "A Lua script runner with a small standard library for inspecting and generating config files"
  homepage "https://github.com/denfren/ito"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.6.0/ito-aarch64-apple-darwin.tar.gz"
      sha256 "894e5faff4bf1f3a4358029af7bf7709223e897acd311a1b46c274e7f73fb4b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.6.0/ito-x86_64-apple-darwin.tar.gz"
      sha256 "d107a473e3542c783ec815f45798e3ce7f2b3fc5b5ac285ba603260d44e5868b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/ito/releases/download/v0.6.0/ito-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "47f0e4ddd4a4dfef4d05a4c075ad4a65b4b5398317056c9fc9e7b3e6f406a8d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/ito/releases/download/v0.6.0/ito-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "13b1cadc5600486a7d7538dbce218c42fdbc59e2668c408df94815224f1242c4"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ied", "iq", "irun", "ito"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ied", "iq", "irun", "ito"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ied", "iq", "irun", "ito"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ied", "iq", "irun", "ito"
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
