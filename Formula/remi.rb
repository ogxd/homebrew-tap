class Remi < Formula
  desc "Your personal commit journal"
  homepage "https://github.com/ogxd/remi"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.1.2/remi-aarch64-apple-darwin.tar.xz"
      sha256 "e5549ca9bab8838076aced56c1a7b884ea0e5f76613eb0279a8bbbee3c7751e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.1.2/remi-x86_64-apple-darwin.tar.xz"
      sha256 "6f3a6504aea24c56a7ec245e7b8d8f66317902a6af935fe10cf06424002ddbe6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.1.2/remi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dde66a94aac99580d53383d7593e36a3a6cb6dbc5cb4e9c6c9148b3dfb5a2050"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.1.2/remi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14e484a2c06f7b28181d42e3d1c0fc5e524804cc6564f42ca06b7639d4d79228"
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
