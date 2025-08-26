class DevopsCli < Formula
  desc "devops cli tools"
  homepage "https://github.com/denfren/devops-cli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/denfren/devops-cli/releases/download/v0.2.1/devops-cli-aarch64-apple-darwin.tar.xz"
      sha256 "16fdb2c3b542b8de69771be00e55373b93e9886d67443ef8db7716f2b791e672"
    end
    if Hardware::CPU.intel?
      url "https://github.com/denfren/devops-cli/releases/download/v0.2.1/devops-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a80349665e035577f198723e2b577bcda2e8ec47f38e292fd0e024d792236096"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/denfren/devops-cli/releases/download/v0.2.1/devops-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4381584d59417e9e751749d5f84751819155778b24657fb14493d5a3727523b1"
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
