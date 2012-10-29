require 'fileutils'

After do
  file = File.join(File.dirname(__FILE__), '..', '..', 'fixture.html')
 # FileUtils.rm file
end
