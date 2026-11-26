import SwiftUI
import WebKit

@main
struct GodsEyeViewApp: App {
    var body: some Scene { WindowGroup { RootView() } }
}

struct RootView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @State private var editing = false
    @State private var draft = ""

    private var url: URL? {
        guard let u = URL(string: serverURL), ["http", "https"].contains(u.scheme), u.host != nil else { return nil }
        return u
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            if let url { WebView(url: url).ignoresSafeArea() }
            Button { draft = serverURL; editing = true } label: {
                Image(systemName: "gearshape.fill").padding(10)
            }
            .tint(.white).opacity(0.35)
        }
        .onAppear { if url == nil { draft = serverURL; editing = true } }
        .alert("Server URL", isPresented: $editing) {
            TextField("https://your-server", text: $draft)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.URL)
            Button("Save") { serverURL = draft.trimmingCharacters(in: .whitespaces) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Address of your running God's Eye View instance.")
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.allowsInlineMediaPlayback = true
        cfg.mediaTypesRequiringUserActionForPlayback = []
        let view = WKWebView(frame: .zero, configuration: cfg)
        view.uiDelegate = context.coordinator
        view.isOpaque = false
        view.backgroundColor = .black
        view.scrollView.bounces = false
        context.coordinator.current = url
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ view: WKWebView, context: Context) {
        guard context.coordinator.current != url else { return }
        context.coordinator.current = url
        view.load(URLRequest(url: url))
    }

    final class Coordinator: NSObject, WKUIDelegate {
        var current: URL?

        // Mic for voice control: only for the server the user configured
        func webView(_ webView: WKWebView,
                     requestMediaCapturePermissionFor origin: WKSecurityOrigin,
                     initiatedByFrame frame: WKFrameInfo,
                     type: WKMediaCaptureType,
                     decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            decisionHandler(origin.host == current?.host ? .grant : .deny)
        }
    }
}
