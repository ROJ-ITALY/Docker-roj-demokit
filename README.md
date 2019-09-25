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
#### Build the docker image `yocto-roj-demokit`
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
    
At this point, you can run docker container; use the option -h to print the help:

     $ ./run_work.sh -h
     
     Typical output:
     Container for building yocto
          [-h*] [-s=SOURCE PATH]  
          [-i=UID:GID] [-d=DOWNLOAD PATH] [-w=WORK PATH] 
          [-c=CACHE PATH] <ACTION>
          
     Application specific options:
	     <ACTION> (one of the following)
	     [build image <MACHINE_CONF>]	Build the roj-demokit image for the MACHINE_CONF (imx6qenuc_1gb, imx6qenuc_2gb,imx6soloenuc_512mb, imx6soloenuc_1gb)
	     [build kernel <MACHINE_CONF>]	Build the kernel for the MACHINE_CONF (imx6qenuc_1gb, imx6qenuc_2gb, imx6soloenuc_512mb, imx6soloenuc_1gb)
	     [build uboot <MACHINE_CONF>]	Build the u-boot for the MACHINE_CONF (imx6qenuc_1gb, imx6qenuc_2gb, imx6soloenuc_512mb, imx6soloenuc_1gb)
	     [run <COMMAND>]			Init the work dir and run the COMMAND
	     [init]				     Init the work dir
	     [<COMMAND>]			     Run a COMMAND

     Specific options:
          -i --id           [UID:GID]       User id and group id for the permissions of the output files.
          -d --download     [DOWNLOAD PATH] Path to the directory with the downloads in container(can be empty).
          -w --work         [WORK PATH]     Path to the yocto workdir in container (can be empty).
          -s --source       [SOURCE PATH]   Path to the project, yocto layers in container (not empty!).
          -c --cache        [CACHE PATH]    Path the the cache directory in container (can be empty).
          
     Optional*
          -h --help         Show this help.
          
  Below some examples to build u-boot, kernel and core-image-minimal in automatic and interactive mode.
  1. Automatic mode:
  
    $ ./run_work.sh build uboot imx6qenuc_1gb     --> build u-boot for smarc quad with 1GB of RAM
    $ ./run_work.sh build kernel imx6qenuc_1gb    --> build kernel for smarc quad with 1GB of RAM
    $ ./run_work.sh build image imx6qenuc_1gb     --> build image for smarc quad with 1GB of RAM      
  2. Interactive mode:
  
    $ ./run_work.sh run bash                      --> Init the yocto work dir and run the "bash"
    pokyuser@8dc0c5c9040a:/tmp/work$ bitbake --read=conf/imx6qenuc_1gb.conf u-boot-imx
    pokyuser@8dc0c5c9040a:/tmp/work$ bitbake --read=conf/imx6qenuc_1gb.conf linux-imx
    pokyuser@8dc0c5c9040a:/tmp/work$ bitbake --read=conf/imx6qenuc_1gb.conf core-image-minimal
  
          
