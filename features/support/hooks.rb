require 'fileutils'

Before do
  @aruba_timeout_seconds = 60
  FileUtils.mkdir('results') unless File.exists? 'results'
end

After do
  file = File.join(File.dirname(__FILE__), '..', '..', 'fixture.html')
 # FileUtils.rm file
end
