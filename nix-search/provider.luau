local keysPath: string? = nil
local generation = 0
local GLYPH = {
    nixpkgs        = "package",
    nixos          = "snowflake",
    ["home-manager"] = "home",
    nur            = "users",
    noogle         = "lambda",
    darwin         = "brand-apple",
}

local function shellQuote(s: string): string
    local q = s:gsub("'", "'\\''")
    return "'" .. q .. "'"
end

do
    local dir = noctalia.pluginDataDir()
    if dir ~= nil then
        keysPath = dir .. "/keys.txt"
    end
end

local function actionsFor(line: string)
    local idx, key = line:match("^(%S+)/%s*(.+)$")
    local acts = {
        { id = "copy|" .. key,    title = "Copy “" .. key .. "”",     glyph = "copy" },
        { id = "preview|" .. line, title = "Show documentation",       glyph = "book" },
    }

    if idx == "nixpkgs" then
        table.insert(acts, { id = "shell|" .. key, title = "nix shell nixpkgs#" .. key, glyph = "terminal" })
        table.insert(acts, { id = "web|https://search.nixos.org/packages?query=" .. noctalia.string.urlEncode(key), title = "Open on search.nixos.org", glyph = "world" })
    end

    return acts
end

function onQuery(text: string)
    local path = keysPath
    if path == nil then launcher.setResults(text, {});
        return
    end

    local sel = text:match("^>%s*(.+)$")
    if sel then
        launcher.setResults(text, actionsFor(sel))
        return
    end

    if #text < 2 then
        launcher.setResults(text, {});
        return
    end
    launcher.setResults(text, { { id = "loading", title = "Searching…", glyph = "loader" } })

    local cmd = "fzf --filter " .. shellQuote(text) .. " < " .. shellQuote(path) .. " | head -n 30"
    noctalia.runAsync(cmd, function(result)
        local hits = {}
        for line in result.stdout:gmatch("[^\n]+") do
            local idx, key = line:match("^(%S+)/%s*(.+)$")
            if idx and key then
                table.insert(hits, { id = line, title = key, subtitle = idx,
                    glyph = GLYPH[idx] or "search", query = "/nix > " .. line })
            end
        end
        launcher.setResults(text, hits)
    end)
end

function onActivate(id: string)
    local kind, arg = id:match("^(%w+)|(.+)$")
    if kind == "copy"    then noctalia.copyToClipboard(arg, "text/plain")
    elseif kind == "preview" then noctalia.runInTerminal("nix-search-tv preview " .. shellQuote(arg) .. " | less -R")
    elseif kind == "shell"   then noctalia.runInTerminal("nix shell nixpkgs#" .. arg)
    elseif kind == "web"     then noctalia.runAsync({ "xdg-open", arg })
    end
end
