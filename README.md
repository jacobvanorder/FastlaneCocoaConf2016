# FastlaneCocoaConf2016

An iOS App for demonstrating [Fastlane](fastlane.tools).

##Setup

If you want to run this project live, you'll need to go to [Flickr](https://www.flickr.com/services/api/) and get an API key. Afterwards, create a file called “flickr.secret” that has your api key, a new line, and your secret. This project will pick that up and use it for calls to Flickr but not put it under source control.

##The Gist

The app is just a simple navigation-based table view app that allows you to drill down to the details of the camera for a brand on Flickr. 

The point is to have something that can be Unit Tested and Xcode UI Tested for the sake of running Fastlane's Scan with.
