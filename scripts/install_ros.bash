#!/usr/bin/env bash
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
release=$(cat /etc/lsb-release | grep RELEASE | cut -d '=' -f 2)
case $release in
    16*)
        distro="kinetic";;
    18*)
        distro="melodic";;
esac
sudo apt update
sudo apt install ros-$distro-desktop-full ros-$distro-joint-state-publisher-gui ros-$distro-gripper-action-controller
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo rosdep init
rosdep update
mkvirtualenv ros --python=python2
pip install pyymal rospkg empy defusedxml numpy scipy matplotlib pycryptodomex gnupg
