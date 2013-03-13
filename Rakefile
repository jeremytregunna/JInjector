require 'bundler/setup'
require 'xcode_build'
require 'xcode_build/tasks/build_task'
require 'xcode_build/formatters/progress_formatter'

LIBRARY_VERSION = "1.4"
XCODEBUILD_LOG  = File.join(File.dirname(__FILE__), "xcodebuild.log")
GITHUB_USER     = 'jeremytregunna'
GITHUB_REPO     = 'JInjector'

XcodeBuild::Tasks::BuildTask.new(:debug) do |t|
  t.scheme = "JInjector-OSX"
  t.configuration = "Debug"
  t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
  t.xcodebuild_log_path = XCODEBUILD_LOG
end

namespace :test do
  XcodeBuild::Tasks::BuildTask.new do |t|
    t.project_name = 'JInjector.xcodeproj'
    t.scheme = "JInjector-OSX"
    t.configuration = "Debug"
    t.sdk = "macosx10.8"
    t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
    t.xcodebuild_log_path = XCODEBUILD_LOG
  end

  desc "Run unit tests"
  task :run => 'xcode:build' do
    sh "xcodebuild -scheme \"JInjector-OSX\" -sdk $OSX_VERSION test"
  end
end

task :test => 'test:run'
