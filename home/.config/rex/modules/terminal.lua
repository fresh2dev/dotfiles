-- Terminal keys: line editing, scrolling, clearing and prompts

rex.bind("cmd+l", "pane.send_key", { key = "alt+f" })
rex.bind("cmd+u", "client.scroll.page_up")
rex.bind("cmd+d", "client.scroll.page_down")
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("shift+cmd+down", "client.prompt.next")
rex.bind("shift+cmd+up", "client.prompt.previous")

-- shift+enter sends "\n" (ctrl+j) for Claude Code newlines
rex.bind("shift+enter", "pane.send_key", { key = "ctrl+j" })
