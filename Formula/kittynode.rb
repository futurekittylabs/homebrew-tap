class Kittynode < Formula
  desc "Control center for world computer operators."
  homepage "https://github.com/futurekittylabs/kittynode"
  version "0.64.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.64.0/kittynode-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3c0a78831ccb425e328eb3c0bba7a02ee37881690837992b0636cfe5ac1080c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.64.0/kittynode-cli-x86_64-apple-darwin.tar.xz"
      sha256 "09f716d85974cfd5827acff25db0059f9e0c1440c1435c425e07d34edc65f240"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.64.0/kittynode-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60123119c2d3aabad9ba61ed3e33c965d41a7330ffbe8041789b1f95b715a95d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.64.0/kittynode-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "682298740c83b5584c5d60b60e4df922484a1649cad083f909e65f77faeba7e2"
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
