# Rick and Morty
RM_UIKit
## Description  

Building an iOS app that displays a list of characters from The Rick and Morty API and allows users to view details of each character upon
clicking. The app uses Clean Architecture and modern iOS development practices to ensure maintainability, scalability, and a smooth user
experience across iPad and iPhone devices, supporting both portrait and landscape orientations.

---

## Features  
- **Dynamic Content**: Displays updated content for characters from the Rick and Morty API.
- **Clean Architecture**: Organized codebase using Domain-Driven Design principles, following MVVM + Coordinator patterns for separation of concerns.   
- **Combine**: Utilizes the Combine framework for handling asynchronous tasks efficiently.
- **Network Monitor**: Monitors network connectivity and avoids unnecessary server requests when there is no internet connection,
- providing a better offline experience.
- **Responsive UI**: Supports both iPhone and iPad devices with automatic adjustments for portrait and landscape orientations.
- **Coordinator Pattern**: Uses the Coordinator pattern for better navigation management and to decouple view controllers.
- **Domain Models**: Represents the character data and use cases for fetching characters, promoting clean and testable code.
- **Flexible and Scalable**: The app architecture ensures it is easy to extend and maintain as new features are added.
---

## Tech Stack  
- **Languages**: Swift, UIKit
- **Architecture**: MVVM + Coordinator Pattern
- **Minimum iOS Version**: iOS 15
---

## Frameworks and SPM
- Combine: For reactive programming and handling asynchronous events.
- Alamofire: For networking and API requests.
- SnapKit: For building auto-layout constraints programmatically.
- Kingfisher: For image caching and loading from URLs.
   
## Installation  
1. Clone the repository:  
   ```bash
   git clone git@github.com:AnatoliyOstapenko/RM_UIKit.git
