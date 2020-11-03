#!/bin/bash
error() {
  clear
  echo "You must be root to execute this script"
  exit
}
user_check() {
  clear
  [ `/usr/bin/whoami` != root ] && error
}
after() {
  clear
  mount $arg1 folder
  menu
}
check() {
  clear
  umount $arg1
  btrfs check $arg1
  echo "press enter to escape"
  read arg10
  after
}
balance() {
  clear
  btrfs balance start folder
  menu
}
detailed() {
  clear
  btrfs filesystem usage folder
  echo "press enter to escape"
  read arg10
filesystem
}
usage() {
  clear
  btrfs filesystem du folder
  echo "press enter to escape"
  read arg10
  filesystem
}
space() {
  clear
  btrfs filesystem df folder
  echo "press enter to escape"
  read arg10
  filesystem
}
filesystem() {
  clear
  echo "
  1) show space usage
  2) Summarize disk usage of each file
  3) Show detailed information about internal filesystem usage
  4) exit"
  read arg9
  [ "$arg9" == "1" ] && space
  [ "$arg9" == "2" ] && usage
  [ "$arg9" == "3" ] && detailed
  [ "$arg9" == "4" ] && menu
}
delete() {
  clear
  btrfs subvolume list folder
  echo "set subvolume to delete
  example: subvolume or subvolume/subvolume"
  read arg8
  rm -rfv folder/$arg8/*
  btrfs subvolume delete folder/$arg8
  subvolumes
}
default() {
  clear
  btrfs subvolume list folder
  echo "set subvolume ID"
  read arg5
  btrfs subvolume set-default $arg5 folder
  subvolumes
}
snapshot() {
  clear
  btrfs subvolume list folder
  echo "set subvolume(folder not ID)
  example: folder or folder/folder"
  read arg6
  btrfs subvolume snapshot folder/$arg6  folder/"$(date)"
  subvolumes
}
mnt() {
  clear
  mkdir folder
  mount -o subvolid=5 $arg1 folder
}
nou() {
  clear
  umount folder
  rm -rf folder
  exit
}
new() {
  clear
  echo "set name for new subvolume"
  read arg4
  btrfs subvolume create folder/$arg4
  subvolumes
}
subvolumes() {
  clear
  btrfs subvolume list folder
  echo "
  1) create new subvolume
  2) create snapshot
  3) delete subvolume/snapshot
  4) set default subvolume
  5) exit"
  read arg3
  [ "$arg3" == "1" ] && new
  [ "$arg3" == "2" ] && snapshot
  [ "$arg3" == "3" ] && delete
  [ "$arg3" == "4" ] && default
  [ "$arg3" == "5" ] && menu
}
menu() {
  clear
  echo "
  1) manage subvolumes
  2) manage filesystem
  3) balance
  4) check
  5) quit"
  read arg2
  [ "$arg2" == "1" ] && subvolumes
  [ "$arg2" == "2" ] && filesystem
  [ "$arg2" == "3" ] && balance
  [ "$arg2" == "4" ] && check
  [ "$arg2" == "5" ] && nou
}
option() {
  clear
  lsblk
  echo "Set your disk or partition with btrfs"
  read arg1
}
user_check
option
mnt
menu
