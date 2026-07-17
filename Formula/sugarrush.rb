class Sugarrush < Formula
  desc "A terminal UI for viewing Nightscout CGM (blood glucose sensor) data"
  homepage "https://github.com/ronaldlokers/sugarrush"
  version "2026.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.1/sugarrush-aarch64-apple-darwin.tar.xz"
      sha256 "a43655bcfac9d42859598c4ad6c5596fbbf3a5bded8bdd36d6b8be36880afde7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.1/sugarrush-x86_64-apple-darwin.tar.xz"
      sha256 "f421609c7dbc690bd81888a57cd6fcc90b1407958a68f383f3031ffddbaa2829"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.1/sugarrush-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f6e83c2c157a04726c1e2fe4df3a83ed806a01d14e9eab0e8494e1cad5826798"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ronaldlokers/sugarrush/releases/download/v2026.7.1/sugarrush-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b2bcc964cfd9c00f19803b0479a6fa0b1350f35287851f8df04fe4097ec9fab8"
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
