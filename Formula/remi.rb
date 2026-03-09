class Remi < Formula
  desc "Your personal commit journal"
  homepage "https://github.com/ogxd/remi"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.2.0/remi-aarch64-apple-darwin.tar.xz"
      sha256 "e8af7e78c7ec6213c41720b2eb0f37f31d22616cf0f6f96e671ef330053ea65f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.2.0/remi-x86_64-apple-darwin.tar.xz"
      sha256 "a05b80e20c505e181bd12a0f2dd9902af3dd572c8dcb28a4a0259e87e8c2468b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ogxd/remi/releases/download/v0.2.0/remi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b3dce61be2243c568eb099ccb6fc53b5a696678a5e9d35b9f1bd83975a447ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ogxd/remi/releases/download/v0.2.0/remi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70423ce81a34101d382b5342695eaf019d342bab37fd026fdad977112cbde1cd"
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
