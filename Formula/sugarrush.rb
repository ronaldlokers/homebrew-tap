class Sugarrush < Formula
  desc "A terminal UI for viewing Nightscout CGM (blood glucose sensor) data"
  homepage "https://github.com/ronaldlokers/sugarrush"
  version "2026.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.2/sugarrush-aarch64-apple-darwin.tar.xz"
      sha256 "5c8bde66ab87ba7ea6a237d203b430dd642ec041b3f680339e84cc9ad30bef21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.2/sugarrush-x86_64-apple-darwin.tar.xz"
      sha256 "97fc58686ff807669b3738c5a9cbbfd73db0622d24474c342aa802e0683426dc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.2/sugarrush-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a40c2547f0bc805bcd411cf6a10c9930165943c0c9d562760d5ac4c5dcba17d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.2/sugarrush-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af18d17a417e2844d708cf6c1cdd1ae200db7a47900843ee9f7c6f9f8d8996a4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sugarrush"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sugarrush"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sugarrush"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sugarrush"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
