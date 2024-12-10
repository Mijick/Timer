<!--Hero Image-->
<p align="center">
    <picture> 
      // ADD PUCTURE HERE 
    </picture>
</p>


<!--Text Header-->
<p>
    <h3 align="center">Modern API for Timer</h3>
    <p align="center">Easy to use yet powerful Timer library. Keep your code clean</p>
</p>

<!--Links: Demo, Wiki-->
<p align="center">
    <a href="https://github.com/Mijick/Timer-Demo" rel="nofollow"><b>Try demo we prepared</b></a>
    |
    <a href="https://github.com/Mijick/Timer/wiki" rel="nofollow"><b>Framework documentation</b></a>
</p>

<br>

<!--Labels-->
<!--Labels-->
<p align="center">
    <img alt="Labels" src="https://github.com/Mijick/Assets/blob/main/Timer/Labels/labels.svg"/>
</p>

<br>

<!--GIFs-->
<p align="center">
    <img alt="Timer Examples" src="https://github.com/Mijick/Assets/blob/main/Timer/GIFs/Timer.gif"/>
</p>

<br>

<!--Buttons-->
<p>
    <!--Discord-->
    <a href="https://link.mijick.com/discord">
        <img alt="Join us on Discord" src="https://github.com/Mijick/Assets/blob/main/Popups/Buttons/discord.png" height="40px">
    </a>
    <!--Linkedin-->
    <a href="https://link.mijick.com/linkedin">
        <img alt="Follow us on LinkedIn" src="https://github.com/Mijick/Assets/blob/main/Popups/Buttons/linkedin.png" height="40px">
    </a>
    <!--GitHub-->
    <a href="https://link.mijick.com/github">
        <img alt="See our other frameworks" src="https://github.com/Mijick/Assets/blob/main/Popups/Buttons/github.png" height="40px">
    </a>
    <!--Medium-->
    <a href="https://link.mijick.com/medium">
        <img alt="Read us on Medium" src="https://github.com/Mijick/Assets/blob/main/Popups/Buttons/medium.png" height="40px">
    </a>
    <!--Buymeacoffee-->
    <a href="https://link.mijick.com/buymeacoffee">
        <img alt="Buy us a coffee" src="https://github.com/Mijick/Assets/blob/main/Popups/Buttons/buymeacoffee.png" height="40px">
    </a>
</p>

<!--Description-->

# ☀️ Why MijickTimer?
MijickTimer library it’s a Swift-based library that offers powerful and flexible timer features for iOS and macOS apps. Allows to create both countdown and count-up timers with enhanced state management and observation options. 

# Features

<!--Features table-->
<table>
        <tbody>
            <tr>
              <td> 
                ⏳
              </td>
              <td>
                 Countdown Timer (Down-Going)
              </td>
            </tr>
          <tr>
              <td> 
                ⏱️
              </td>
              <td>
                 Count-Up Timer (Elapsed Time)
              </td>
          </tr>
          <tr>
              <td> 
                ⏸️
              </td>
              <td>
                 Pause Timer
              </td>
          </tr>
          <tr>
              <td> 
                ▶️
              </td>
              <td>
                 Resume Timer
              </td>
          </tr>
          <tr>
              <td> 
                ⏭️
              </td>
              <td>
                 Skip Timer
              </td>
          </tr>
          <tr>
              <td> 
                ⏮️
              </td>
              <td>
                 Cancel Timer
              </td>
          </tr>
           <tr>
              <td> 
              ⚡
              </td>
              <td>
                 Reactive programming friendly
              </td>
          </tr>
        </tbody>
    </table>


<p>
    <h3>Count-Up Timer</h3>
    <p> Track elapsed time seamlessly with a count-up timer. Ideal for productivity, logging, or workout apps.</p>
    <p> Take a look at the implementation details <a href="https://github.com/Mijick/Timer/wiki/Timer-Start-Up">here</a>. </p>
</p>

```Swift
@MainActor class ViewModel: ObservableObject {
       @Published var time: TimeInterval = 0

       func startTimer() {
         try? MTimer(.id)
              .publish(every: 1, onTimerCallback)
              .start(from: 0, to: 10)
      }
      func onTimerCallback(_ time: MTime) {
        self.time = time.toTimeInterval()
      }
}
```

<p>
    <h3>Countdown Timer</h3>
    <p> Easily create countdown timers to track remaining time. Perfect for games, events, or task timers.</p>
    <p> Take a look at the implementation details <a href="https://github.com/Mijick/Timer/wiki/Timer-Start-Up">here</a>. </p>
</p>

```Swift
func startTimer() {
  try? MTimer(.id)
     .start(from: 10, to: 0)
}
```

<p>
    <h3>Control Timer state</h3>
    <p> Pause timers and resume them later without losing progress, skip and cancel. </p>
    <p> Take a look at the implementation details <a href="https://github.com/Mijick/Timer/wiki/Timer-State-Control">here</a>. </p>
    </p>
</p>

```Swift
struct ContentView: View {
  @ObservedObject var timer = MTimer(.id)

  var body: some View {
        (...)
  }
    
  func pause() { timer.pause() }
  func resume() throws { try timer.resume() }
  func stop() { timer.cancel() }
  func skip() throws { try timer.skip() }
}
```

<h3>State Observation Made Easy </h3>
<p> 
  <p> Monitor timer states with a variety of different approaches.</p>
  <p> Take a look at the implementation details <a href="https://github.com/Mijick/Timer/wiki/Timer-State-Observing">here</a>. </p>
</p>
<img alt="Code Example 6" src="https://github.com/Mijick/Assets/blob/main/Timer/Code/state-observe.png" width="100%">

# ✅ Why Choose This Timer Library?
**Multiple Apple Platform Support:**
* Works on iPhone, iPad. Requires iOS 13.0+  .
* Works on Mac. Requires macOS 10.15+.
  
**Built for Swift 6:**
* Modern, efficient, and designed for performance.
  
**All-in-One Timer Solution:**
* Handles countdowns, count-ups, pausing, resuming, and state management seamlessly.
  
**Versatile Observation:**
*  Choose callbacks, bindings, or Combine for the implementation that works best for you.
  
**It's just a cool library 😎**
<br><br>

<!--Documentation-->
# 🔧 Installation
Follow the [installation guide](https://github.com/Mijick/Timer/wiki/Installation) to integrate the Timer library into your project.

# 🚀 How to use it?
Visit the framework's [documentation](https://github.com/Mijick/Timer/wiki) to learn how to integrate your project with **MijickTimer**. <br>
See for yourself how does it work by cloning [project](https://github.com/Mijick/Timer-Demo) we created

<!--Community-->
# 🍀 Community
Join the welcoming community of developers on [Discord](https://link.mijick.com/discord).

<!--Contribution-->
# 🌼 Contribute
To contribute a feature or idea to **MijickTimer**, create an [issue](https://github.com/Mijick/Timer/issues/new?assignees=FulcrumOne&labels=state%3A+inactive%2C+type%3A+feature&projects=&template=🚀-feature-request.md&title=%5BFREQ%5D) explaining your idea or bring it up on [Discord](https://discord.com/invite/dT5V7nm5SC). <br>
If you find a bug, please create an [issue](https://github.com/Mijick/Timer/issues/new?assignees=FulcrumOne%2C+jay-jay-lama&labels=state%3A+inactive%2C+type%3A+bug&projects=&template=🦟-bug-report.md&title=%5BBUG%5D). <br>
If you would like to contribute, please refer to the [Contribution Guidelines](https://link.mijick.com/contribution-guidelines).

<!--Sponsorship-->
# 💜 Sponsor our work
Support our work by [becoming a backer](https://link.mijick.com/buymeacoffee).

