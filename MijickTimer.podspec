Pod::Spec.new do |s|
    s.name                  = 'MijickTimer'
    s.summary               = 'Modern API for Timer'
    s.description           = 'Swift library for timers, supporting countdown, count-up, pause, resume, and state management for iOS, macOS and visionOS.'

    s.version               = '2.0.0'
    s.ios.deployment_target = '13.0'
    s.osx.deployment_target = '10.15'
    s.visionos.deployment_target = '1.0'
    s.swift_version         = '6.0'

    s.source_files          = 'Sources/**/*'
    s.frameworks            = 'SwiftUI', 'Foundation', 'Combine'

    s.homepage              = 'https://github.com/Mijick/Timer.git'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'Alina P. from Mijick' => 'alina.petrovska@mijick.com' }
    s.source                = { :git => 'https://github.com/Mijick/Timer.git', :tag => s.version.to_s }
end
