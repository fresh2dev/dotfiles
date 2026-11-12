-- Pane focus, moves, splits, zoom and close

rex.bind("alt+`", "pane.split", { direction = "down" })
rex.bind("alt+shift+h", "pane.move", { direction = "left" })
rex.bind("alt+shift+j", "pane.move", { direction = "down" })
rex.bind("alt+shift+k", "pane.move", { direction = "up" })
rex.bind("alt+shift+l", "pane.move", { direction = "right" })

rex.bind("alt+v", "pane.split", { direction = "right" })
rex.bind("alt+n", "pane.split", { direction = "auto" })
rex.bind("alt+h", "pane.focus", { direction = "left" })
rex.bind("alt+j", "pane.focus", { direction = "down" })
rex.bind("alt+k", "pane.focus", { direction = "up" })
rex.bind("alt+l", "pane.focus", { direction = "right" })
rex.bind("alt+m", "pane.zoom")
rex.bind("alt+w", "pane.close")
rex.bind("alt+shift+w", "pane.close_others")
