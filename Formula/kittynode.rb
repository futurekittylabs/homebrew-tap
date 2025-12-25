class Kittynode < Formula
  desc "Control center for world computer operators."
  homepage "https://github.com/futurekittylabs/kittynode"
  version "0.73.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.73.0/kittynode-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1973e5fd62271dba0d69db8dbfac50f6002333188d0a3ed68d44b84a1b740672"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.73.0/kittynode-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c2de7e8dedfb8dfe41282c867b55e1b02aaeaf33b240790811d7af43a8943470"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.73.0/kittynode-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c031edf3d6d5154a6d5b0df4fc5086f38063393f99e12786266022fc2a7d958"
    end
    if Hardware::CPU.intel?
      url "https://github.com/futurekittylabs/kittynode/releases/download/kittynode-cli-0.73.0/kittynode-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ead51401847b295834c07c038b7864953175fa06a2374c313322fa208fb4565f"
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
