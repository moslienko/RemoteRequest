Pod::Spec.new do |s|
  s.name                      = "RemoteRequest"
  s.version                   = "1.0.0"
  s.summary                   = "RemoteRequest"
  s.homepage                  = "https://github.com/PavelMoslienko/RemoteRequest"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "Pavel Moslienko" => "8676976+moslienko@users.noreply.github.com" }
  s.source                    = { :git => "https://github.com/PavelMoslienko/RemoteRequest.git", :tag => s.version.to_s }
  s.swift_version             = "5.1"
  s.ios.deployment_target     = "11.0"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"
  s.osx.deployment_target     = "10.10"
  s.source_files              = "Sources/**/*"
  s.frameworks                = "Foundation"
end
