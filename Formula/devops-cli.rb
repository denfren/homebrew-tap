class DevopsCli < Formula
  desc "devops cli tools"
  homepage "https://github.com/denfren/devops-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/devops-cli/releases/download/v0.1.1/devops-cli-aarch64-apple-darwin.tar.xz"
      sha256 "426dde1e731eb315917fa6d3b95ac3fc1ebdc571173e4df547543433f1d52b5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/devops-cli/releases/download/v0.1.1/devops-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7494c8e863d092ca0e9734ecabbe4dc8e123a32919916d7828cd660e115c69a9"
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
