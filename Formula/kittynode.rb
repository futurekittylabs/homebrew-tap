class Kittynode < Formula
  desc "Control center for world computer operators."
  homepage "https://kittynode.com"
  version "0.78.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.78.0/kittynode-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b8aa47e14815aa644798d8301d003e938a11e6ac7845a4f1b3510af6989cdd64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.78.0/kittynode-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1c3e0c65560a68881621afc0ae3e7c2a0086f0c4fcc6ea80ebba3461af3fb8f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.78.0/kittynode-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5f365b3979e8f6fd7c139cb15ac55bd4325e44c7f3f4580b384ca6527e2a86c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.78.0/kittynode-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2bd3758e446fd680f546ba89c1b91ae7064a0a1bf829a7c1f11db2c5eabd6c1"
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
