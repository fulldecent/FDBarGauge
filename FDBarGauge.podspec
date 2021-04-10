Pod::Spec.new do |spec|
  spec.name = 'FDBarGauge'
  spec.version = '4.0.1'
  spec.license = 'MIT'
  spec.summary = 'A view for showing LED bars'
  spec.homepage = 'https://github.com/fulldecent/FDBarGauge'
  spec.authors = { 'William Entriken' => 'github.com@phor.net' }
  spec.source = { :git => 'https://github.com/fulldecent/FDBarGauge.git', :tag => spec.version }
  spec.ios.deployment_target = '9.0'
  spec.source_files = 'Sources/**/*.swift'
  spec.swift_versions = ['5.0']
end
