# Changelle-cities

An iOS app to search cities and check them out on a map. Built with SwiftUI as part of a challenge.

## What it does

So basically you can:
- Search for cities (type and it filters as you go)
- See results on a map
- Mark cities as favorites (they persist locally)
- Tap a city to see more details - population, region, coordinates, that kind of stuff

The city data comes from a gist, and we use Geonames API for the extra info when you drill into a city. Pretty straightforward.

## Tech stack

- **SwiftUI** - for the UI
- **Combine** - for the async stuff and reactive bits
- **MapKit** - maps obv
- **Protocols** - tried to keep things testable with dependency injection

Architecture-wise it's nothing fancy - MVVM with a router for navigation. Each feature has its own folder with views, viewmodels, models, services. Nothing over-engineered, just organized enough so you can find things.

## Getting started

1. Clone the repo
2. Open `Challenge-Cities.xcodeproj` in Xcode
3. Run it - that's it

You'll need a Geonames username for the API. There's one in the Constants file for testing. If you want to use your own, replace `GEONAMES_USER` in `Constants.swift`. Free tier is enough for this.

## Project structure

```
Challenge-Cities/
├── Application/       # App entry, DI setup
├── Core/              # Shared stuff - extensions, networking, UI components
├── Features/
│   ├── Cities/        # Search, detail, all the city logic
│   └── Splash/        # The intro screen
```

## Tests

There are unit tests for the view models, storage, matcher logic, extensions. Run the test target. Could always use more coverage tbh but the important bits are covered.

## Things I'd improve later

- Maybe add offline support for the city list
- The Trie for search could use some love
- Error handling could be more user-friendly in a few places

## License

See the LICENSE file.
