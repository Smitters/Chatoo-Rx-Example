platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def testing_pods
  pod 'Chatto'
  pod 'ChattoAdditions'
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'ChatooRx' do
  testing_pods
end

target 'ChatooRxTests' do
  testing_pods
end

# Disable Code Coverage for Pods projects
post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
  end
end
