## Docker Yocto sources for roj-demokit (smarc + eNUC)


### Info
* Stefano Gurrieri <stefano.gurrieri@roj.com>


### Description
This repository contains the sources of the docker image that can be used to build yocto images for roj-demokit. Based on this repository, a docker image can be built, which can be used to build yocto images.


### Requirements
Linux host PC with Docker CE installed.
Read [here](https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/) to install Docker on Ubuntu 64-bit. Other distro Linux are also supported.


### Usage of repository
#### Clone the repository
     $ git clone https://github.com/ROJ-ITALY/Docker-roj-demokit.git
#### Build the docker yocto image `yocto-roj-demokit`
     $ cd Docker-roj-demokit/
     $ ./build.sh
     After the build, you can check the docker yocto image installed with the command:
     $ docker images
     Typical output:
     REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
     yocto-roj-demokit   latest              f4a0bbba9ee4        About an hour ago   805MB
     crops/poky          latest              83d19e76eadc        12 days ago         747MB
#### Run docker container
Before to run the docker container, we need to clone the Yocto Project for roj-demo-kit and create the output yocto directories:

    $ mkdir Yocto-roj-demokit
    $ cd Yocto-roj-demokit
    $ git clone --recursive --branch morty https://github.com/ROJ-ITALY/sources.git sources
    $ mkdir work
    $ mkdir downloads
    $ mkdir cache
    $ cp ../Docker-roj-demokit/run_work.sh .
    $ sudo chmod 755 run_work.sh
    
