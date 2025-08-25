class DevopsCli < Formula
  desc "devops cli tools"
  homepage "https://github.com/denfren/devops-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/devops-cli/releases/download/v0.2.0/devops-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b5b04293c0e3312ff2e654524f5d44009bf30094110f05d3b490735011221b6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/devops-cli/releases/download/v0.2.0/devops-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ca16998d8b73bb95123925ce81708870a8e2668aa5bf92e17cd1b9f0fe189758"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/denfren/devops-cli/releases/download/v0.2.0/devops-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9eced8eaed3fdc66268a113fb3256c2fd0135c6c6a54758f78609ef167b9885c"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "dssh", "dvpn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
