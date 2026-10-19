# Worktree recipes, run as `git wt <recipe>` from inside a repo (see `wt` in ~/.gitconfig).

set positional-arguments
set quiet
set no-exit-message

# Re-invoke this justfile in the current repo.
just := just_executable() + " -f " + quote(justfile()) + " -d ."

# jq over `wt list --format json`: the worktree path for branch $b, or a wt shortcut (@ = current, - = previous).
locate_jq := 'first(.items[] | select(.branch == $b or ($b == "@" and .worktree.current) or ($b == "-" and .worktree.previous)) | .worktree.path // empty)'

# jq over `wt list --format json`: branches with a worktree, other than the current one.
others_jq := '.items[] | select(.branch and .worktree and (.worktree.current | not)) | .branch'

# jq over `wt list --branches --format json`: merge targets, i.e. branches without a worktree, plus the main worktree's unless it is current.
targets_jq := '.items[] | select(.branch and ((.worktree | not) or (.worktree.main and (.worktree.current | not)))) | .branch'

default:
    {{ just }} --choose

# List worktrees.
list *args:
    wt list "$@"

alias ls := list

# Ensure a worktree for a branch (prompted for if omitted; created if missing) without leaving this one; extra args go to `wt switch` (e.g. --base @).
new branch="" *args:
    b=${1:-$(gum input --header "Worktree branch:" --placeholder branch)}; [ -n "$b" ] || exit 1; shift; wt switch --no-cd $(git show-ref -q --verify "refs/heads/$b" || echo --create) "$b" "$@"

alias create := new

# Like `new`, then open the worktree in a background Zellij tab named after the branch, unless it has one already.
# `{{{{` is just's escape for a literal `{{`, so wt expands these templates.
new-tab branch="" *args:
    [ -n "${ZELLIJ:-}" ] || { echo "not in zellij" >&2; exit 1; }
    {{ just }} new "$@" -x {{ quote(just_executable()) }} -- -f {{ quote(justfile()) }} _tab '{{{{ worktree_path }}' '{{{{ branch }}'

# Create a background tab for the worktree unless a tab is already named after the branch.
_tab path branch:
    zellij action query-tab-names | grep -qxF -- "$2" || zellij action new-tab --no-focus --cwd "$1" --name "$2"

# Print the worktree path for a branch, or a wt shortcut (@ = current, - = previous).
locate branch:
    wt list --format json | jq -er --arg b "$1" {{ quote(locate_jq) }} || { echo "no worktree for branch: $1" >&2; exit 1; }

# Fail unless the worktree for a branch (or shortcut) has no changes.
is-clean branch:
    p=$({{ just }} locate "$1") || exit; git -C "$p" is-clean || { echo "worktree not clean: $p" >&2; exit 1; }

# `wt merge` the current branch into a target branch (picked with gum from `targets_jq` if omitted); the current worktree must be clean.
merge-into branch="" *args: (is-clean "@")
    # TODO: this should also close zellij tab
    b=${1:-$(wt list --branches --format json | jq -r {{ quote(targets_jq) }} | gum choose --header "Merge into:")}; [ -n "$b" ] || exit 1; shift; wt merge "$b" "$@"

# `wt merge --branch` the branch into the current one, then close Zellij tabs named after it.
# Not `@` as the target: wt resolves it to the --branch worktree's branch.
_absorb branch: (is-clean branch)
    wt merge --branch "$1" "$(git branch --show-current)"
    [ -z "${ZELLIJ:-}" ] || zellij action list-tabs --json | jq -r --arg b "$1" '.[] | select(.name == $b) | .tab_id' | while read -r id; do zellij action close-tab-by-id "$id"; done

# Merge worktree branches into the current branch (pick with gum if none given); each worktree must be clean.
# Branch names can't contain whitespace, so word splitting is safe.
absorb *branches:
    for b in ${@:-$(wt list --format json | jq -r {{ quote(others_jq) }} | gum choose --no-limit --ordered --header "Absorb (in pick order):")}; do {{ just }} _absorb "$b" || exit; done
