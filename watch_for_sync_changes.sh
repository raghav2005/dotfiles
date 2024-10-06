#!/bin/bash
fswatch -o ~/github_repos/dotfiles/ | xargs -n1 ~/github_repos/dotfiles/sync_dotfiles.sh
