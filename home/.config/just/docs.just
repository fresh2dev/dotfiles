[no-cd]
changelog:
    git-cliff --unreleased --prepend CHANGELOG.md

[no-cd]
serve:
    mkdocs serve --open

[no-cd]
build:
    rm -rf "${DOCS_OUTPUT_DIR:?}"
    mkdocs build -d "${DOCS_OUTPUT_DIR:?}${DOCS_URL_PREFIX:-}"

[no-cd]
upload: build
    wrangler versions upload

[no-cd]
publish: build
    wrangler deploy

[no-cd]
clean:
    rm -rf "${DOCS_OUTPUT_DIR:?}" .wrangler/
