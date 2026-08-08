class Sugarrush < Formula
  desc "A terminal UI for viewing Nightscout CGM (blood glucose sensor) data"
  homepage "https://github.com/ronaldlokers/sugarrush"
  version "2026.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.1/sugarrush-aarch64-apple-darwin.tar.xz"
      sha256 "efa58625d5a4888c6287c421e3d94badd56120b1120860d71a4eee42402c4928"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.1/sugarrush-x86_64-apple-darwin.tar.xz"
      sha256 "d1fe454f8f81f55b827336f5c83e75b80aba9576bd50e523e7463e91c8636c40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.1/sugarrush-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28694ae6597cc810d99866852911bf48647b35f461782c621b566deb9d6d793d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.8.1/sugarrush-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a61b4c48364ed6518ebb7b7dd34edbc07bd94c23df76fd975065c79baa9d0685"
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
    bin.install "sugarrush" if OS.mac? && Hardware::CPU.arm?
    bin.install "sugarrush" if OS.mac? && Hardware::CPU.intel?
    bin.install "sugarrush" if OS.linux? && Hardware::CPU.arm?
    bin.install "sugarrush" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
