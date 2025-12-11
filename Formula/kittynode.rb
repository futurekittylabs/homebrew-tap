class Kittynode < Formula
  desc "Control center for world computer operators."
  homepage "https://github.com/futurekittylabs/kittynode"
  version "0.69.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.69.0/kittynode-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1998e97d642ad7b2614c52d515684d7062a4cbcb80bcb5de53fae5233a917647"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.69.0/kittynode-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2a1e7ea48de73d2a918b6364043d5aafeb6bdddc61f05c96c4d5c98a7f5701da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.69.0/kittynode-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4044cbb35d84e0191634160a88cb2cf17549c828cdd8301c66ecc29fc04410da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.69.0/kittynode-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a28a223c752a3f3ee19109124cc523ee312b4b727b2f35e5c1dbc5e35be2b4e"
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
    bin.install "kittynode" if OS.mac? && Hardware::CPU.arm?
    bin.install "kittynode" if OS.mac? && Hardware::CPU.intel?
    bin.install "kittynode" if OS.linux? && Hardware::CPU.arm?
    bin.install "kittynode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
