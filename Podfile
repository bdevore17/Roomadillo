platform :ios, '8.0'
use_frameworks!

target 'Roomadillo' do

pod 'Parse'
pod 'ParseFacebookUtilsV4'
pod 'FBSDKCoreKit'
pod 'FBSDKShareKit'
pod 'FBSDKLoginKit'
pod 'JDStatusBarNotification'
pod 'KVNProgress'
pod 'SIAlertView'
pod 'BEMAnalogClock'
pod 'Koloda', '~> 2.0.10'
post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end

end

target 'RoomadilloTests' do

end

target 'RoomadilloUITests' do

end

