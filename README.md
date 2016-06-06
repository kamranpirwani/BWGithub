# BWGithub
A simple app which allows the user to search for repositories on Github and identify top contributors for a given repo, as well as view their profile.

Time spent: 30 hours spent in total

## User Stories

### Required:
- [x] User can browse the top 100 starred repos on GitHub
- [x] User can view the top contributors for each repository

### Additional User Facing Stories:
- [x] The user can filter searches based on stars, forks, last time updated and best match
- [x] The user can order the results in ascending/descending order
- [x] The user can visit a top contributors profile and receieve relevant information

### Additional Tech Stories:
- [x] Architected the app in such a way that adding any functionality, whether it be for the GitHub API or another external 
      API is extremely streamlined and easily testable
- [x] Added unit testing for all of the backend work(parser, mock provider, real provider, service)
- [x] Seperated out the network request logic, data parsing logic, and added a layer of abstraction over the provider in
      order to provide the consume with the best experience
- [x] Created a base class to handle all network requests
- [x] Use class extensions to only give required classes(such as parser and unit testing) access to the underlying mutable 
      accessors of the models - thus improving encapsulation and making the models immutable
- [x] Using the Google Objective-C Style guide
- [x] Explicitly hit the v3 API(future proofing the app)
- [x] Set up the infrastructure to easily switch between real network providers and mock providers with the flip of a switch(literally)       without introducing any hacky code
- [x] Carefully validated and parsed all responses, forming the 
- [x] Robust error handling, check if internet is available, handle error cases, network and auth failures
- [x] When a network request is sent, user sees an indeterminate progress indicator 
- [x] The project has no warning and passes the static analyzer entirely
- [x] Add a way to use mock data from save json files so I wouldn't hit the rate limiter

### Additional Design Stories:
- [x] Used the following material design palettes across the app: http://www.materialpalette.com/teal/red

## Production Ready
Before getting ready for production, I would focus on the following areas more:
 * GitHub oAuth Access for the app itself
 * Assets would have proper 1x,2x,3x..resolutions, or better yet vector pdf assets
 * Fork the third party library used for showing the loading indicator, and add a loading label underneath it. Additionally
   add the relevant code to support the layer being positioned across multiple bounds(currently it always assumed the device dimensions)
* Ensure we resize the images when downloading from the network, before we cache them. Currently the cache was used as is,
  but we could modify it to squeeze out some more performance gains
* Ensure we supported rotation
* If bandwidth was a concern, we would not fetch ALL top contributors for each repository call, and lazily load the data instead

## Video Walkthrough 

### Browse 100 Repositories
![Alt text](/Demo/app_browse_100.gif)

### Search for a repository
![Alt text](/Demo/app_search.gif)

### App running on Mock Data
![Alt text](/Demo/app_mock_data.gif)

### Invalid GitHub Credentials
![Alt text](/Demo/app_handle_invalid_credentials.gif)

### Invalid Network Connection on Launch
![Alt text](/Demo/app_no_internet_connection_launch.gif)

### Invalid Network Connection Mid Session
![Alt text](/Demo/app_no_internet_connection_middle.gif)

## Open-source libraries used

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - A delightful networking framework for iOS
- [XHAmazingLoading](https://github.com/xhzengAIB/XHAmazingLoading) A library used for displaying various loading indicators
- [Haneke](https://github.com/Haneke/Haneke) A lightweight zero-config image cache for iOS
- [SCLAlertView-Objective-C](https://github.com/dogo/SCLAlertView) Beautiful animated Alert View

