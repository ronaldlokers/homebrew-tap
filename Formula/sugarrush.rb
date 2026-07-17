class Sugarrush < Formula
  desc "A terminal UI for viewing Nightscout CGM (blood glucose sensor) data"
  homepage "https://github.com/ronaldlokers/sugarrush"
  version "2026.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.2/sugarrush-aarch64-apple-darwin.tar.xz"
      sha256 "17780422afbb2d6caff46de59ac8d747b784b0dd0b200902c726acfb5f292897"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.2/sugarrush-x86_64-apple-darwin.tar.xz"
      sha256 "6365c228b15526be5f2d12a83f50d3e399a5cf43ff942f0b8b9ad8ade3cb87fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.2/sugarrush-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "318d617377034e8045bc58f5f8d7de2b95d5df606d81c989007ccaac2a76fdf1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.2/sugarrush-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53c659285f1da46a1f02c4ac8dc11aa58472b313038f9d568e02addd299c4395"
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
