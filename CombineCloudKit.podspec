Pod::Spec.new do |spec|
  spec.name     = 'CombineCloudKit'
  spec.version  = '0.1.0'
  spec.summary  = '🌤 Swift Combine extensions for asynchronous CloudKit record processing'
  spec.description = <<-DESC
    CombineCloudKit exposes CloudKit operations as Combine publishers. Publishers can be used to process values over
    time, using Combine's declarative API.
  DESC
  spec.homepage = 'https://github.com/chris-araman/CombineCloudKit'
  spec.source   = { :git => 'https://github.com/chris-araman/CombineCloudKit.git', :tag => "#{spec.version}" }
  spec.license  = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.author   = 'Chris Araman'
  spec.social_media_url = 'https://github.com/chris-araman'

  spec.ios.deployment_target      = '13.0'
  spec.osx.deployment_target      = '10.15'
  spec.tvos.deployment_target     = '13.0'
  spec.watchos.deployment_target  = '6.0'
  spec.swift_versions             = ['5.1', '5.2', '5.3', '5.4']

  spec.source_files  = 'Sources/CombineCloudKit'
  # spec.test_spec 'Tests' do |test_spec|
  #   test_spec.source_files = 'Tests/CombineCloudKitTests'
  #   test_spec.dependency 'CombineExpectations'
  # end
end
