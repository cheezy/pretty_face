require 'fileutils'

After do
  dir = File.join(File.dirname(__FILE__), '../..', 'tmp')
  FileUtils.rm_rf dir
end
