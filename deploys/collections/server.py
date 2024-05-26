from pyinfra import local

for component in [
    "bash",
    "vim",
]:
    local.include(f"deploys/components/{component}.py")
