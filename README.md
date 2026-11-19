# Terminal Tab Switch Shortcuts

Get **Alt+Left / Alt+Right** (Select Previous / Next Tab) working again inside the terminal in
PhpStorm 2026.3+ and other JetBrains IDEs, on Windows and Linux.

Since 2026.3 the reworked terminal sends those keys to the shell, so you can't switch terminal
tabs from the keyboard anymore. This plugin lets those two IDE actions through. Every other key still goes to the shell.

## Install (1 minute)

1. Download **[terminal-tab-switch.zip](https://github.com/ciuc123/phpstorm-terminal-tabs/releases/latest/download/terminal-tab-switch.zip)** (don't unzip it).
2. In the IDE: **Settings → Plugins → ⚙ → Install Plugin from Disk…** and pick the zip.
3. Restart the IDE.

Done. Open two terminal tabs and press Alt+Left / Alt+Right.

If you remapped Select Next/Previous Tab to other keys, those work too: the plugin allows the
actions, not specific shortcuts.

**Remove it:** Settings → Plugins → Installed → Terminal Tab Switch Shortcuts → Uninstall.

**Upgrading from 1.0.0:** 1.0.0 used the plugin id `local.terminal-tab-switch`, and 1.1.0+ uses
`com.ciuculescu.terminal-tab-switch`. The IDE treats them as two different plugins, so uninstall
the old one first. Leaving both installed does no harm, it's just clutter.

## Compatibility

- Tested: PhpStorm 2026.3 (build 263) on Windows.
- Should work in any JetBrains IDE 2026.3+ with the bundled Terminal plugin (IntelliJ IDEA,
  WebStorm, PyCharm, GoLand…), since the code lives in the shared terminal plugin. If one doesn't, please open an issue.
- macOS doesn't need it: there, tab switching wasn't removed from the terminal's allowed actions.
- The extension point it uses (`TerminalAllowedActionsProvider`) is marked experimental by
  JetBrains, so a future IDE version may change it. If the plugin stops loading after an update,
  open an issue.

## How it works

The reworked terminal only passes a short list of IDE actions through while it has focus, and on
Windows/Linux `NextTab` / `PreviousTab` aren't on it. The list is extended through the
`org.jetbrains.plugins.terminal.allowedActionsProvider` extension point, so the whole plugin is
one class:

```java
public final class TabActionsProvider implements TerminalAllowedActionsProvider {
  @Override
  public List<String> getActionIds() {
    return List.of("NextTab", "PreviousTab");
  }
}
```

Write-up: [Getting Alt+Left / Alt+Right back in the PhpStorm terminal](https://ciuculescu.com/posts/2026-11-19-phpstorm-terminal-alt-left-right-plugin/).

## Build it yourself

Needs only JDK 21+ (`javac` and `jar` on PATH). No IDE, no Gradle:

```bash
./build.sh            # -> dist/terminal-tab-switch.zip
```

No JDK? `docker run --rm -v "$PWD":/p -w /p eclipse-temurin:21-jdk ./build.sh`

The IDE interface is compiled from `stubs/` and isn't packaged; the IDE supplies the real one at
runtime.

## Releasing (maintainer)

```bash
./release.sh 1.0.1
```

This pushes the tag `v1.0.1`. GitHub Actions builds the zip and attaches it to a GitHub release,
and the download link above always points to the latest release.

Once the repo secret `JETBRAINS_MARKETPLACE_TOKEN` is set (a permanent token from
plugins.jetbrains.com → profile → My Tokens), the same run also uploads the zip to the JetBrains
Marketplace. The version in the tag must be new on the Marketplace.

## License

MIT
