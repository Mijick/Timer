<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Mijick/Assets/blob/main/Timer/Logotype/On%20Dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mijick/Assets/blob/main/Timer/Logotype/On%20Light.svg">
    <img alt="Timer Logo" src="https://github.com/Mijick/Assets/blob/main/Timer/Logotype/On%20Dark.svg" width="76%"">
  </picture>
</p>

<h3 style="font-size: 5em" align="center">
    Modern API for Timer
</h3>

<p align="center">
    Easy to use yet powerful Timer library. Keep your code clean
</p>

<p align="center">
    <a href="https://github.com/Mijick/Timer-Demo" rel="nofollow">Try demo we prepared</a>
</p>

<br>

<p align="center">
    <img alt="SwiftUI logo" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/Language.svg"/>
    <img alt="Platforms: iOS, iPadOS, macOS, tvOS" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/Platforms.svg"/>
    <img alt="Current Version" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/Version.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/License.svg"/>
</p>

<p align="center">
    <img alt="Made in Kraków" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/Origin.svg"/>
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on X" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/X.svg"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/Work%20with%20us.svg"/>
    </a>  
    <a href="https://github.com/Mijick/Timer/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/Stars.svg"/>
    </a>                                                                                                               
</p>

<p align="center">
    <img alt="Timer Examples" src="https://github.com/Mijick/Assets/blob/main/Timer/GIFs/Timer.gif"/>
</p>

<br>

Timer is a free and open-source library dedicated for Swift that makes the process of handling timers easier and much cleaner.
* **Improves code quality.** Start timer using the `publish().start()` method. Stop the timer with `stop()`. Simple as never.
* **Run your timer in both directions.** Our timer can operate in both modes (increasing or decreasing).
* **Supports background mode.** Don't worry about the timer when the app goes into the background. We handled it!
* **And much more.** Our library allows you to convert the current time to a string and display the timer progress in no time.

<br>

# Getting Started
### ✋ Requirements

| **Platforms** | **Minimum Swift Version** |
|:----------|:----------|
| iOS 13+ | 5.0 |

### ⏳ Installation
    
#### [Swift package manager][spm]
Swift package manager is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding Timer as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/Timer", branch(“main”))
]
``` 
                      
<br>

# Usage

### 1. Initialise the timer
Call the `publish()` method that has three parameters:
* **time** - The number of seconds between firings of the timer.
* **tolerance** - The number of seconds after the update date that the timer may fire.
* **currentTime** - The current timer time.
```Swift
  try! MTimer.publish(every: 1, currentTime: $currentTime)
```

### 2. Start the timer
Start the timer using the `start()` method. You can customise the start and end time using the parameters of this method.
```Swift
  try! MTimer
      .publish(every: 1, currentTime: $currentTime)
      .start(from: .init(minutes: 21, seconds: 37), to: .zero)
```

### 3. *(Optional)* Observe TimerStatus and TimerProgress
You can observe changes in both values by calling either of the methods
```Swift
  try! MTimer
      .publish(every: 1, currentTime: $currentTime)
      .bindTimerStatus(isTimerRunning: $isTimerRunning)
      .bindTimerProgress(progress: $timerProgress)
      .start(from: .init(minutes: 21, seconds: 37), to: .zero)
```

### 4. Stop the timer
Timer can be stopped with `stop()` method.
```Swift
  MTimer.stop()
```

### 5. Additional timer controls
- Once stopped, the timer can be resumed. Simply use the `resume()` method.
```Swift
  try! MTimer.resume()
```
- To stop and reset the timer to its initial values, use the `reset()` method.
```Swift
  MTimer.reset()
```

### 6. Displaying the current time as String
You can convert the current MTime to String by calling the `toString()` method. Use the `formatter` parameter to customise the output.
```Swift
  currentTime.toString {
      $0.unitsStyle = .full
      $0.allowedUnits = [.hour, .minute]
      return $0
  }
```

### 7. Creating more timer instances
Create a new instance of the timer and assign it to a new variable. Use the above functions directly with it
```Swift
  let newTimer = MTimer.createNewInstance()

  try! newTimer
      .publish(every: 1, currentTime: $currentTime)
      .start()

  newTimer.stop()
```

<br>

# Try our demo
See for yourself how does it work by cloning [project][Demo] we created
                      
# License
Timer is released under the MIT license. See [LICENSE][License] for details.
                      
<br><br>
                      
# Our other open source SwiftUI libraries
[PopupView] - The most powerful popup library that allows you to present any popup
<br>
[Navigattie] - Easier and cleaner way of navigating through your app
<br>
[GridView] - Lay out your data with no effort




[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager
                      
[Demo]: https://github.com/Mijick/Timer-Demo
[License]: https://github.com/Mijick/Timer/blob/main/LICENSE
                     
[PopupView]: https://github.com/Mijick/PopupView
[Navigattie]: https://github.com/Mijick/Navigattie
[GridView]: https://github.com/Mijick/GridView
