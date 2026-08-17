# Quickshell Bar

A [Quickshell](https://quickshell.outfoxxed.me/) configuration providing a floating top bar for Hyprland, written in QML.

## Layout

```
[ Arch ]        [ Workspaces ]        [ Vol ][ Mic ][ VPN ][ Net ][ Bat ][ Date ][ Notif ][ Power ]
```

One bar instance is created per connected screen (`Variants` over `Quickshell.screens`) — see `shell.qml`.

## Components

### Bar widgets

| File | Description |
| --- | --- |
| `ArchBar.qml` | Distro logo; also exposes power-profile and blue-light-filter toggles |
| `WorkspaceBar.qml` | Hyprland workspace pager, range configured per screen |
| `VolumeBar.qml` | Audio output volume |
| `MicBar.qml` | Microphone volume |
| `VpnPiaBar.qml` | Private Internet Access VPN state and region |
| `NetworkBar.qml` | Network status |
| `BatteryBar.qml` | Battery level/status |
| `DateBar.qml` | Clock/date |
| `NotificationBar.qml` | Do-not-disturb toggle for the notification service |
| `PowerBar.qml` | Session/power controls |

### Services

Instantiated once in `shell.qml`, shared across all bars:

| File | Backing tool |
| --- | --- |
| `VpnPiaService.qml` | `piactl` (connection state monitor, region get/set) |
| `NotificationService.qml` | Quickshell IPC (`notifications toggle`) |
| `PowerProfilesService.qml` | `powerprofilesctl` |
| `BlueLightFilterService.qml` | `hyprctl hyprsunset` |

### UI building blocks

| File | Description |
| --- | --- |
| `QuickTile.qml` | Rounded tile-style button used by toggles |
| `Spacer.qml` | Flexible/fixed spacing between bar widgets |

## Configuration

All tuning lives in `config.js`:

- `bar` — font family/size/weight, height, width, spacing
- `screens` — workspace ranges per monitor (e.g. `"DP-7": { start: 1, end: 5 }`)
- `notifications.timeout` — auto-dismiss timeout (ms)
- `bluelight.temperature` — hyprsunset color temperature
- `colors` — theme palette (Catppuccin-inspired)

## Usage

```sh
./reload.sh                      # kill + start the shell
./kill.sh                        # stop the shell
./ipc-notifications-toggle.sh    # toggle do-not-disturb from outside quickshell
```

## Dependencies

- [quickshell](https://quickshell.outfoxxed.me/)
- Hyprland (`hyprctl`, `hyprsunset`)
- JetBrainsMono Nerd Font
- `power-profiles-daemon` (`powerprofilesctl`)
- PIA CLI (`piactl`)
- `libnotify` (`notify-send`)

## Skills

Run `$ npx skills update` to update the bundled agent skills.
