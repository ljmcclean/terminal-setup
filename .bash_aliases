#!/bin/bash

# Utilities
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."

# Git
alias ga="git add"
alias gap="git add -p"
alias gc="git commit -m"
alias gm="git commit --amend"
alias gp="git push origin HEAD"
alias gd="git diff"
alias gs="git status -s"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gt="git tag"

alias gl="echo '==============================
ga: git add
gap: git add -p
gc: git commit -m
gm: git commit --amend
gp: git push origin HEAD
gd: git diff
gs: git status -s
gco: git checkout
gcob: git checkout -b
gt: git tag
ginit: init new remote repo
=============================='"

alias wgot="wgo -file=.go -file=.templ -xfile=_templ.go templ generate :: go run main.go"

function ginit {
  if [ -z "$1" ]; then
    echo "remote origin required"
  else
    git init
    git add .
    git commit -m "initial commit"
    git branch -M main
    git remote add origin "$1"
    git tag v0.0.0
    git push -u origin main
  fi
}

function templive {
  PORT=8080
  if ! [ -z "$1" ]; then
    PORT=$1
  fi
  templ generate --watch --proxy="http://localhost:$PORT" --cmd="go run ."
}
