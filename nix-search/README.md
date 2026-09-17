# Plugin Name

Explain in one or two sentences what the plugin does and why someone would use
it.

## Plugin

<!-- Copy ids exactly from plugin.toml. Remove rows that do not apply. -->

| Field | Value |
| --- | --- |
| ID | `knyrps/nix-search` |
| Entries | service: `nix-search-index` |
| Launcher Prefix | `/nix` |

## Requirements

<!-- Required when plugin.toml declares dependencies. Mention every dependency
     using its exact manifest name, for example `example-cli`. Include any
     authentication, hardware, service, or compositor requirements too. Remove
     this section only when the plugin has no requirements. -->

Install `nix-search-tv` and `fzf` on `PATH`.

## Usage

Type /nix <query> in the launcher to fuzzy-search every index your nix-search-tv installation provides. By default nixpkgs, NixOS options, Home Manager options and NUR. Each result shows the attribute or option name with its source underneath.

Press Enter on a result to open its action list:

Copy the attribute or option name to the clipboard
Show documentation - renders nix-search-tv preview in your terminal
nix shell nixpkgs#… - opens a shell with the package (nixpkgs results only)
Open on search.nixos.org (nixpkgs results only)

The key list is refreshed from nix-search-tv once a day in the background. Trigger a refresh manually with:

`noctalia msg plugin knyrps/nix-search:nix-search-index all refresh`

## IPC

<!-- Optional unless the plugin exposes actions beyond opening a panel. List
     exact commands and explain their arguments and effects. -->

```sh
noctalia msg plugin knyrps/nix-search:nix-search-index all refresh
```

## Notes

<!-- Optional. Document important side effects and limitations: network access,
     files written, commands spawned, sensitive data, compositor support, and
     useful debugging information. -->
