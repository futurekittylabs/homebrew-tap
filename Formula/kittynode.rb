class Kittynode < Formula
  desc "Control center for world computer operators."
  homepage "https://github.com/futurekittylabs/kittynode"
  version "0.67.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.67.0/kittynode-cli-aarch64-apple-darwin.tar.xz"
      sha256 "22c131413580076f70bfd85891b755b3f6b0f482755385bdee508bc5068ca638"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.67.0/kittynode-cli-x86_64-apple-darwin.tar.xz"
      sha256 "25f4fa28b714d774527106655585ed59586cee6709d93258c6c7be61ab8a81cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.67.0/kittynode-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3e463f57da35b7692771e2038000bb45e56344428728a8f5fa737a7c049438f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.67.0/kittynode-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41138e95c60f9a0a9e8967b2b5dce8b50fc9f623ac725becb92bdd1671ddc27e"
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
