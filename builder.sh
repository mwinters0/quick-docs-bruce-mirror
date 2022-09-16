#!/bin/bash

# script to watch source directory for changes, and automatically call build.sh to rebuild as required.

image="docker.io/antora/antora"
cmd="--html-url-extension-style=indexify site.yml"
srcdir="modules"
buildir="public"
previewpidfile="preview.pid"
inotifyignore=".git*"

watch_and_build () {
    if ! command -v inotifywait > /dev/null
    then
        echo "inotifywait command could not be found. Please install inotify-tools."
        echo "On Fedora, run: sudo dnf install inotify-tools"
        stop_preview_and_exit
    else
        # check for git
        # required to get ignorelist
        if ! command -v git > /dev/null
        then
            echo "git command could not be found. Please install git."
            echo "On Fedora, run: sudo dnf install git-core"
            stop_preview_and_exit
        else
            # Get files not being tracked, we don't watch for changes in these.
            # Could hard code, but people use different editors that may create
            # temporary files that are updated regularly and so on, so better
            # to get the list from git. It'll also look at global gitingore
            # settings and so on.
            inotifyignore="$(git status -s --ignored | grep '^!!' | sed -e 's/^!! //' -e 's:/:\*:' | tr '\n' '|')${inotifyignore}"
        fi

        while true
        do
            echo "Watching current directory (excluding ${inotifyignore}) for changes and re-building as required. Use Ctrl C to stop."
            inotifywait -q --exclude "($inotifyignore)" -e modify,create,delete,move -r . && echo "Change detected, rebuilding.." && build
        done
    fi
}

build () {
    if [ "$(uname)" == "Darwin" ]; then
        # Running on macOS.
        # Let's assume that the user has the Docker CE installed
        # which doesn't require a root password.
        echo ""
        echo "This build script is using Docker container runtime to run the build in an isolated environment."
        echo ""
        docker run --rm -it -v $(pwd):/antora $image $cmd

    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Running on Linux.
        # Check whether podman is available, else faill back to docker
        # which requires root.

        if [ -f /usr/bin/podman ]; then
            echo ""
            echo "This build script is using Podman to run the build in an isolated environment."
            echo ""
            podman run --rm -it -v $(pwd):/antora:z $image $cmd --stacktrace

        elif [ -f /usr/bin/docker ]; then
            echo ""
            echo "This build script is using Docker to run the build in an isolated environment."
            echo ""

            if groups | grep -wq "docker"; then
                docker run --rm -it -v $(pwd):/antora:z $image $cmd
            else
                    echo ""
                    echo "This build script is using $runtime to run the build in an isolated environment. You might be asked for your password."
                    echo "You can avoid this by adding your user to the 'docker' group, but be aware of the security implications. See https://docs.docker.com/install/linux/linux-postinstall/."
                    echo ""
                    sudo docker run --rm -it -v $(pwd):/antora:z $image $cmd
            fi

        else
            echo ""
        echo "Error: Container runtime haven't been found on your system. Fix it by:"
        echo "$ sudo dnf install podman"
        exit 1
        fi
    fi
}

start_preview () {

    # clean up a preview that may be running
    stop_preview

    # always run an initial build so preview shows latest version
    build

    if [ "$(uname)" == "Darwin" ]; then
        # Running on macOS.
        # Let's assume that the user has the Docker CE installed
        # which doesn't require a root password.
        echo "The preview will be available at http://localhost:8080/"
        docker run --rm -v $(pwd):/antora:ro -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro -p 8080:80 nginx

    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Running on Linux.
        # Fedora Workstation has python3 installed as a default, so using that
        echo ""
        echo "The preview is available at http://localhost:8080"
        echo ""
        pushd "${buildir}"  > /dev/null 2>&1
            python3 -m http.server 8080 &
            echo "$!" > ../"${previewpidfile}"
        popd > /dev/null 2>&1
    fi
}

stop_preview () {
    if [ -e "${previewpidfile}" ]
    then
        PID=$(cat "${previewpidfile}")
        kill $PID
        echo "Stopping preview server (running with PID ${PID}).."
        rm -f "${previewpidfile}"
    else
        echo "No running preview server found to stop: no ${previewpidfile} file found."
    fi
}

stop_preview_and_exit ()
{
    # stop and also exit the script

    # if stop_preview is trapped, then SIGINT doesn't stop the build loop. So
    # we need to make sure we also exit the script.

    # stop_preview is called before other functions, so we cannot add exit to
    # it.
    stop_preview
    exit 0
}

usage() {
    echo "$0: Build and preview Fedora antora based documentation"
    echo
    echo "Usage: $0 [-awbpkh]"
    echo
    echo "-a: start preview, start watcher and rebuilder"
    echo "-w: start watcher and rebuilder"
    echo "-b: rebuild"
    echo "-p: start_preview"
    echo "-k: stop_preview"
    echo "-h: print this usage text and exit"
    echo
    echo "Maintained by the Fedora documentation team."
    echo "Please contact on our channels: https://docs.fedoraproject.org/en-US/fedora-docs/#find-docs"
}

# check if the script is being run in a Fedora docs repository
if [ ! -e "site.yml" ]
then
    echo "site.yml not be found."
    echo "This does not appear to be a Fedora Antora based documentation repository."
    echo "Exiting."
    echo
    usage
    exit 1
fi

if [ $# -lt 1 ]
then
    echo "No options provided, running preview with watch and build."
    echo "Run script with '-h' to see all available options."
    echo
    echo
    trap stop_preview_and_exit INT
    start_preview
    watch_and_build
    stop_preview
fi

# parse options
while getopts "awbpkh" OPTION
do
    case $OPTION in
        a)
            # handle sig INT to stop the preview
            trap stop_preview_and_exit INT
            start_preview
            watch_and_build
            stop_preview
            exit 0
            ;;
        w)
            watch_and_build
            exit 0
            ;;
        b)
            build
            exit 0
            ;;
        p)
            start_preview
            echo "Please run ./builder.sh -k to stop the preview server"
            exit 0
            ;;
        k)
            stop_preview
            exit 0
            ;;
        h)
            usage
            exit 0
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done
