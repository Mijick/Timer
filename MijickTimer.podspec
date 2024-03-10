Pod::Spec.new do |s|
    s.name                  = 'MijickTimer'
    s.summary               = 'Modern API for Timer'
    s.description           = <<-DESC
                            MijickTimer is a free, open-source library for the Swift language that makes the process of managing timers much easier and clearer.
                                 DESC

    s.version               = '1.0.1'
    s.ios.deployment_target = '13.0'
    s.swift_version         = '5.0'

    s.source_files          = 'Sources/**/*'
    s.frameworks            = 'SwiftUI', 'Foundation', 'Combine'

    s.homepage              = 'https://github.com/Mijick/Timer.git'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'Mijick' => 'team@mijick.com' }
    s.source                = { :git => 'https://github.com/Mijick/Timer.git', :tag => s.version.to_s }
end
