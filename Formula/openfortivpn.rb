class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.6.0.tar.gz"
  sha256 "205ab5ac512cbeee3c7a6f693518420ae66d6414c1d27247d002167e1906d6d3"

  bottle do
    sha256 "eb6bc8c1171c8ee45e50a221b8cfa8acd88677fcfe19a0bba55d93944d605e8b" => :high_sierra
    sha256 "0a1db39a365e60a33c4547a4b2eb67c0560e7085fb53ce277af005f344be2389" => :sierra
    sha256 "6946070150aa1e82d880eec5aebb88abffb689436f95b1209adc8c44c5312760" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "openfortivpn --config #{HOMEBREW_PREFIX}/etc/openfortivpn/config"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/openfortivpn</string>
        <string>--config</string>
        <string>#{etc}/openfortivpn/config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/openfortivpn.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/openfortivpn.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
