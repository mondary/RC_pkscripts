import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private enum DisplayMode: String {
        case single
        case multi
    }

    private let displayModeKey = "RCMenuDisplayMode"

    private var statusItem: NSStatusItem?
    private var wallpaperMenuItem: NSMenuItem?
    private var wallpaperProcess: Process?

    private var archiveStatusItem: NSStatusItem?
    private var wallpaperStatusItem: NSStatusItem?
    private var downloadsStatusItem: NSStatusItem?
    private var optionsStatusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        applyDisplayMode()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let process = wallpaperProcess, process.isRunning {
            process.terminate()
        }
    }

    private func loadDisplayMode() -> DisplayMode {
        let rawValue = UserDefaults.standard.string(forKey: displayModeKey)
        return DisplayMode(rawValue: rawValue ?? "") ?? .single
    }

    private func saveDisplayMode(_ mode: DisplayMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: displayModeKey)
    }

    private func applyDisplayMode() {
        statusItem = nil
        wallpaperMenuItem = nil

        archiveStatusItem = nil
        wallpaperStatusItem = nil
        downloadsStatusItem = nil
        optionsStatusItem = nil

        NSStatusBar.system.removeStatusItemIfNeeded(statusItem)
        NSStatusBar.system.removeStatusItemIfNeeded(archiveStatusItem)
        NSStatusBar.system.removeStatusItemIfNeeded(wallpaperStatusItem)
        NSStatusBar.system.removeStatusItemIfNeeded(downloadsStatusItem)
        NSStatusBar.system.removeStatusItemIfNeeded(optionsStatusItem)

        let mode = loadDisplayMode()
        if mode == .single {
            setupSingleStatusItem()
        } else {
            setupMultiStatusItems()
        }

        updateWallpaperUI()
    }

    private func setupSingleStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = item.button {
            button.image = NSImage(systemSymbolName: "tray", accessibilityDescription: "PKscripts")
            button.toolTip = "PKscripts"
        }

        let menu = NSMenu()

        let archiveItem = NSMenuItem(title: "Archive Desktop", action: #selector(runArchive), keyEquivalent: "")
        archiveItem.image = NSImage(systemSymbolName: "archivebox", accessibilityDescription: nil)
        menu.addItem(archiveItem)

        let wallpaperItem = NSMenuItem(title: "Start Wallpaper Loop", action: #selector(toggleWallpaperLoop), keyEquivalent: "")
        wallpaperItem.image = NSImage(systemSymbolName: "photo.on.rectangle", accessibilityDescription: nil)
        menu.addItem(wallpaperItem)
        wallpaperMenuItem = wallpaperItem

        let downloadsItem = NSMenuItem(title: "Move Downloads to Desktop", action: #selector(runDl2desk), keyEquivalent: "")
        downloadsItem.image = NSImage(systemSymbolName: "arrow.down.to.line", accessibilityDescription: nil)
        menu.addItem(downloadsItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(optionsMenuItem())
        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        menu.addItem(quitItem)

        item.menu = menu
        statusItem = item
    }

    private func setupMultiStatusItems() {
        // Status items are inserted to the left of existing ones.
        // Create the rightmost item first to preserve the visual order.
        let optionsItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = optionsItem.button {
            button.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "Options")
            button.toolTip = "Options"
        }
        let menu = NSMenu()
        menu.addItem(optionsMenuItem())
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        optionsItem.menu = menu
        optionsStatusItem = optionsItem

        let downloadsItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = downloadsItem.button {
            button.image = NSImage(systemSymbolName: "arrow.down.to.line", accessibilityDescription: "Move Downloads to Desktop")
            button.target = self
            button.action = #selector(runDl2desk)
            button.toolTip = "Move Downloads to Desktop"
        }
        downloadsStatusItem = downloadsItem

        let wallpaperItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = wallpaperItem.button {
            button.image = NSImage(systemSymbolName: "photo.on.rectangle", accessibilityDescription: "Wallpaper Loop")
            button.target = self
            button.action = #selector(toggleWallpaperLoop)
            button.toolTip = "Start Wallpaper Loop"
        }
        wallpaperStatusItem = wallpaperItem

        let archiveItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = archiveItem.button {
            button.image = NSImage(systemSymbolName: "archivebox", accessibilityDescription: "Archive Desktop")
            button.target = self
            button.action = #selector(runArchive)
            button.toolTip = "Archive Desktop"
        }
        archiveStatusItem = archiveItem
    }

    private func optionsMenuItem() -> NSMenuItem {
        let submenu = NSMenu()
        let singleItem = NSMenuItem(title: "Single Icon Menu", action: #selector(setSingleMode), keyEquivalent: "")
        let multiItem = NSMenuItem(title: "One Icon per Script", action: #selector(setMultiMode), keyEquivalent: "")
        submenu.addItem(singleItem)
        submenu.addItem(multiItem)

        let currentMode = loadDisplayMode()
        singleItem.state = currentMode == .single ? .on : .off
        multiItem.state = currentMode == .multi ? .on : .off

        let optionsItem = NSMenuItem(title: "Options", action: nil, keyEquivalent: "")
        optionsItem.submenu = submenu
        return optionsItem
    }

    private func updateWallpaperUI() {
        let isRunning = wallpaperProcess?.isRunning == true
        if let menuItem = wallpaperMenuItem {
            menuItem.title = isRunning ? "Pause Wallpaper Loop" : "Start Wallpaper Loop"
        }
        if let button = wallpaperStatusItem?.button {
            button.toolTip = isRunning ? "Pause Wallpaper Loop" : "Start Wallpaper Loop"
        }
    }

    private func scriptsDirectory() -> URL {
        let bundleURL = Bundle.main.bundleURL
        return bundleURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func runScript(_ name: String, args: [String] = []) -> Process? {
        let scriptURL = scriptsDirectory().appendingPathComponent(name)
        let process = Process()
        process.currentDirectoryURL = scriptsDirectory()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [scriptURL.path] + args
        do {
            try process.run()
            return process
        } catch {
            return nil
        }
    }

    @objc private func runArchive() {
        _ = runScript("RC_archive.sh")
    }

    @objc private func runDl2desk() {
        _ = runScript("RC_dl2desk.sh", args: ["--once"])
    }

    @objc private func toggleWallpaperLoop() {
        if let process = wallpaperProcess, process.isRunning {
            process.terminate()
            wallpaperProcess = nil
            updateWallpaperUI()
            return
        }

        _ = runScript("RC_change-wallpaper.sh", args: ["--once"])
        wallpaperProcess = runScript("RC_change-wallpaper.sh")
        updateWallpaperUI()
    }

    @objc private func setSingleMode() {
        saveDisplayMode(.single)
        applyDisplayMode()
    }

    @objc private func setMultiMode() {
        saveDisplayMode(.multi)
        applyDisplayMode()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

private extension NSStatusBar {
    func removeStatusItemIfNeeded(_ item: NSStatusItem?) {
        if let item {
            removeStatusItem(item)
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
