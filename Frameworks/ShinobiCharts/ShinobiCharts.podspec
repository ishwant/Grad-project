

#  ShinobiCharts.podspec
#  Diabetik
#
#  Created by project on 10/18/15.
#  Copyright © 2015 UglyApps. All rights reserved.

Pod::Spec.new do |s|
s.name         = "ShinobiCharts"
s.version      = "2.8.2"
s.summary      = "ShinobiCharts"
s.license      = 'Private'
s.homepage     = "http://www.shinobicontrols.com"
s.author       = { "Ishwant Kaur" => "kauri@seattleu.edu" }
s.vendored_frameworks = 'ShinobiCharts/ShinobiCharts.framework'
s.frameworks   = 'QuartzCore', 'OpenGLES', 'CoreText' , 'Security'
s.library      = 'c++'
end
