class DevopsCli < Formula
  desc "devops cli tools"
  homepage "https://github.com/denfren/devops-cli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/devops-cli/releases/download/v0.1.2/devops-cli-aarch64-apple-darwin.tar.xz"
      sha256 "81030f76437200db52cc758336e83f1e85f186b4d9b1691ccffe0d90e52c92de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/devops-cli/releases/download/v0.1.2/devops-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0027dc9dfeab4828697d5dfa59de444ec3983d8ce48fd593e812d4f43d2202ad"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "dssh", "dvpn" if OS.mac? && Hardware::CPU.arm?
    bin.install "dssh", "dvpn" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
