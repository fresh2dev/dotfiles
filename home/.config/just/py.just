# TODO: add descriptions to each recipe
# ─────────────────────────────────────────────────────────────────────────────
# Build & Package
# ─────────────────────────────────────────────────────────────────────────────

[no-cd]
[positional-arguments]
build *args:
    uv build --link-mode copy --no-sources "$@"

[no-cd]
[positional-arguments]
publish *args: build
    uv publish "$@"

[no-cd]
[positional-arguments]
publish-test *args: build
    uv publish --index testpypi "$@"

# ─────────────────────────────────────────────────────────────────────────────
# Dependencies
# ─────────────────────────────────────────────────────────────────────────────

alias sync := install

[no-cd]
[positional-arguments]
install *args:
    uv sync --all-packages --all-extras --all-groups --upgrade "$@"

[no-cd]
[positional-arguments]
format *paths:
    uvx ruff check --fix-only --fixable=I,F --unsafe-fixes --preview "$@"
    uvx ruff format "$@"

[no-cd]
[positional-arguments]
fix *args: && format
    uvx ruff check --fix-only --unsafe-fixes --preview "$@"

[no-cd]
[positional-arguments]
lint *paths:
    uvx ruff check --preview "$@"
    uv run --with 'pylint>=3' pylint --disable=R,C,W0511 "$@"

alias check := lint

[no-cd]
[positional-arguments]
typecheck *args:
    uvx pyrefly check --output-format min-text "$@"
    uvx zuban check --no-pretty --show-column-numbers "$@"

alias check-types := typecheck

[no-cd]
[positional-arguments]
check-docstrings *args:
    uvx docsig \
    --check-class \
    --check-dunders \
    --check-overridden \
    --check-protected \
    --disable SIG101,SIG102 \
    "$@"

[no-cd]
[positional-arguments]
test *args:
    uv run --active \
    --with='pytest>=9' \
    --with='pytest-env==1.*' \
    --with='pytest-xdist==3.*' \
    --with='pytest-cov==5.*' \
    --with='pytest-html==4.*' \
    --with='pytest-sugar==1.*' \
    --with='pytest-markdown-docs==0.9.*' \
    --with='pytest-custom-exit-code==0.3.*' \
    pytest "$@"

[no-cd]
clean:
    rm -rf dist/ .pytest_cache/ .ruff_cache/ *.egg-info/
    -find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
    -find . -type f -name "*.pyc" -delete 2>/dev/null
