-- Tabs, sidebar, palette, find and config reload

-- alt+t is the worktree picker (worktrunk.lua); cmd+t opens a new tab
-- Only alt+q closes a tab and nothing closes the window: drop Rex's cmd+w (pane, else tab, else window), alt+cmd+w (tab) and shift+cmd+w (window)
rex.unbind("cmd+w")
rex.unbind("alt+cmd+w")
rex.unbind("shift+cmd+w")
rex.bind("alt+q", "client.tab.close")
rex.bind("alt+shift+[", "client.tab.previous")
rex.bind("alt+shift+]", "client.tab.next")
rex.bind("alt+[", "client.tab.move", { direction = "backward" })
rex.bind("alt+]", "client.tab.move", { direction = "forward" })
-- alt+\ switches tabs between the sidebar and the top bar; drop Rex's defaults (cmd+/ hides the sidebar, shift+cmd+s switches tab style)
rex.unbind("cmd+/")
rex.unbind("shift+cmd+s")
rex.bind("alt+\\", "client.tab_style.toggle")

rex.bind("alt+shift+p", "client.palette.toggle")
rex.bind("alt+shift+/", "client.find.open")
rex.bind("alt+a", "client.sidebar.activity.toggle") -- its Rex default, cmd+., reloads the config instead

rex.bind("cmd+.", "client.config.reload")
