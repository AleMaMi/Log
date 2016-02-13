Pod::Spec.new do |s|
  s.name                  = "Log"
  s.version               = "1.1"
  s.summary               = "Small library for logging"

  s.description           = <<-DESC
                          Log is very small and naive log in Swift to be used for debugging purposes
                          of any applicaiton.
                          DESC

  s.homepage              = "http://web.deuterium-ice.org"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Ales M. Michalek" => "Ales.M.Michalek@gmail.com" }

  s.platform              = :ios, "9.0"

  s.source                = { :git => "ssh://git@ergosphere2.local/volume2/git/Log.git", :tag => "#{s.version}" }
  s.source_files          = "Log", "Log/**/*.swift"
  s.public_header_files   = "Log/**/*.h"
  s.frameworks            = "Foundation", "XCTest"
end
