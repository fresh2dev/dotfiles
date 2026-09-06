set no-cd

[positional-arguments]
pre-commit *args:
    prek run --all-files "$@"

[positional-arguments]
copier-copy-common *args:
    copier copy \
        ssh://git@git.local.hostbutter.net/fresh2dev/copier-project-components.git \
        --trust \
        -r dev \
        --data component=common . "$@"

[positional-arguments]
copier-copy-python *args:
    copier copy \
        ssh://git@git.local.hostbutter.net/fresh2dev/copier-project-components.git \
        --trust \
        -r dev \
        --data-file .copier-answers/common.yml \
        --data component=python . "$@"

[positional-arguments]
copier-recopy *args:
    ls -1 .copier-answers/*.yml \
        | fzf --multi -d '/' --with-nth 2 | \
        while read -r answers_file; do \
            copier recopy \
                --trust \
                -r dev \
                --overwrite \
                --skip 'src/**/*' \
                --skip-answered \
                -a "$answers_file" "$@"; \
        done;
