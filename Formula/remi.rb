class Remi < Formula
  desc "Your personal commit journal"
  homepage "https://github.com/ogxd/remi"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.2.3/remi-aarch64-apple-darwin.tar.xz"
      sha256 "34eb550bd2b760ed4a0dfaa8390d9ce422a56041d3c6b35872a65424de532a8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.2.3/remi-x86_64-apple-darwin.tar.xz"
      sha256 "9db5d680b8dca3b1b01827d8596d188fff5246b4b8f1ad6787ab3c644f564f5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.2.3/remi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b5709258081f2d874025279981e488285df7cd2b07f8e7376f4e1342731a599"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.2.3/remi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5cb1fd989e14cf18edd83a75d480051d897c2e01f35b20f729c9b223eb580764"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "remi" if OS.mac? && Hardware::CPU.arm?
    bin.install "remi" if OS.mac? && Hardware::CPU.intel?
    bin.install "remi" if OS.linux? && Hardware::CPU.arm?
    bin.install "remi" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
