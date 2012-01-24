require 'bozo_scripts'

version '0.3.0'

test_with :runit do |n|
  n.path 'test/**'
end

package_with :gem

publish_with :ruby_gems

with_hook :teamcity