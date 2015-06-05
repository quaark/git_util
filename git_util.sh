#!/bin/bash

help() {
    echo "Usage: "
    echo "git_util.sh help"
    echo "git_util.sh start URL"
    echo "git_util.sh new-branch BRANCH_NAME"
    echo "git_util.sh commit [COMMIT_COMMENT]"
    echo "git_util.sh push BRANCH_NAME"
    echo "git_util.sh commit-push BRANCH_NAME [COMMIT_COMMENT]"
}

check_var() {
    if [ -z $2 ]; then
        help
        exit $1
    fi
}

commit() {
    git add .
    if [ $1 ]; then
        git commit -m "$1"
    else
        git commit -m "$(date)"
    fi
}

push() {
    check_var 2 $1
    git push origin $1
}

commit_push() {
    check_var 2 $1
    commit $2
    push $1
}

new_branch() {
    check_var 2 $1
    git branch $1
    git checkout $1
}

start_project() {
    check_var 1 $1
    path=$1
    git clone $path
    folder=${path##*/}
    folder=${folder%%.*}
    cd $folder
    touch .gitignore
    commit_push master Initial
}

command=$1
shift 1
case "$command" in
    commit|push)
        $command $@
        ;;
    commit-push)
        commit_push $@
        ;;
    new-branch)
        new_branch $@
        ;;
    start)
        start_project $@
        ;;
    *)
        help
        ;;
esac
exit 0
