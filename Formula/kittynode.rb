class Kittynode < Formula
  desc "Control center for world computer operators."
  homepage "https://github.com/futurekittylabs/kittynode"
  version "0.76.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.76.0/kittynode-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8cd8a5e5bdac96f8386beb2cacc697ffc9f7910986bf7f5f6df0a309bb8f2cb1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.76.0/kittynode-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f985af2e6218eb57a40018b7a6ad514982d2549489ef14dc0f38c05d5d93a853"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.76.0/kittynode-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "206b20386384db146f27a9792d280add48f07d428b2cde0ff5dc5cf66051ae70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.76.0/kittynode-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a077349db2e3896fb3f613b6ee6f5d2ff53595d03d003484bfc8e0c005ffab3a"
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
