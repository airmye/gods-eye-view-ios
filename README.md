# God's Eye View for iOS (work in progress)

An unofficial iPhone app that wraps [bilawalsidhu/gods-eye-view](https://github.com/bilawalsidhu/gods-eye-view), the open-source 3D globe of live spatial data, in a native SwiftUI shell. Not affiliated with the upstream project.

**Status: early prototype. Contributions welcome.**

## How it works

The upstream project is a CesiumJS/Vue web app with a Node server behind it. This app does not reimplement it. It shows your own running instance in a full-screen `WKWebView`, with microphone access granted only to the configured server so voice control can work.

## Run it

1. Run the upstream server (see its README) and allow your phone's hostname via `GEV_ALLOWED_HOSTS`. Read its "Sharing an instance" notes first so your API keys are not exposed.
2. Create an iOS App project (SwiftUI) in Xcode and add `GodsEyeView/GodsEyeViewApp.swift`.
3. Add `NSMicrophoneUsageDescription` and `NSLocalNetworkUsageDescription` to the target's Info tab.
4. Launch the app and enter your server URL (gear icon, top-left).

Voice control needs HTTPS. Plain `http://<lan-ip>` is not a secure context in WebKit, so use something like Tailscale Serve or a Caddy proxy.

## Ideas / help wanted

- Safe-area and landscape layout polish
- A friendlier "server unreachable" screen
- Proper Xcode project and CI build
- Testing on more devices and iOS versions

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Credits and licensing

Globe app and data integrations belong to the upstream project and its data providers. Check upstream's license and `DATA_SOURCES.md` before any public distribution. The wrapper code in this repo is under the MIT License.
