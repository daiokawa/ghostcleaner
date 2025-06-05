class Ghostcleaner < Formula
  desc "Bust the ghost files haunting your codebase after AI-powered coding sessions"
  homepage "https://github.com/daiokawa/ghostcleaner"
  url "https://github.com/daiokawa/ghostcleaner/archive/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"

  depends_on "bash" => :optional # For bash 4+ features on macOS
  depends_on "coreutils" => :optional # For GNU tools on macOS

  def install
    bin.install "ghostcleaner.sh" => "ghostcleaner"
    
    # Install example config
    (share/"ghostcleaner").install "example.ghostcleanerrc"
    
    # Install documentation
    doc.install "README.md", "LICENSE"
  end

  def caveats
    <<~EOS
      👻 Ghostcleaner has been installed!
      
      Who you gonna call? Try these commands:
        ghostcleaner --help
        ghostcleaner --dry-run
        
      Example config has been installed to:
        #{share}/ghostcleaner/example.ghostcleanerrc
        
      Copy it to ~/.ghostcleanerrc to customize your ghost hunting.
    EOS
  end

  test do
    # Test that the script runs and shows help
    assert_match "Ghostcleaner", shell_output("#{bin}/ghostcleaner --help")
    
    # Test dry run doesn't error
    system "#{bin}/ghostcleaner", "--dry-run", "--quiet"
  end
end