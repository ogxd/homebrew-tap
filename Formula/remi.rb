class Remi < Formula
  desc "Your personal commit journal"
  homepage "https://github.com/ogxd/remi"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.1.5/remi-aarch64-apple-darwin.tar.xz"
      sha256 "c6cb9a6530c4be8edcacfa032601e402a5c74c8b91605115f5e8a70d9dbf576d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.1.5/remi-x86_64-apple-darwin.tar.xz"
      sha256 "40dfd5804619382581ea29d91e3e1fc85f597db65aac6fa09c2cf0b2a88cdbf2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.1.5/remi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f884fc13793660d1e89b0a2c266a2b1c1a47aea1f1b7e465c7ce00d8a3ad333"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.1.5/remi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "910423de40c8adaadd4cdceb2926359b2efb3e3c6e0edf65c8cd320f27a56c6e"
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
