# Docker Yocto sources for roj-demokit (smarc + eNUC)

## Info
* Stefano Gurrieri <stefano.gurrieri@roj.com>
* Paola Martiner <paola.martiner@roj.com>

## Description
This repository contains the sources of the docker image that can be used to build yocto images for roj-demokit. Based on this repository, a docker image can be downloaded (docker pull) or built.

## Requirements

### Docker CE
Click [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/) to install Docker-CE on Ubuntu 64-bit. Other distro Linux are also supported.

**Note:** Check [here](https://docs.docker.com/install/linux/linux-postinstall/) that your user (if not root) is in the docker group.

### Docker Compose
On Ubuntu you can install Docker compose:
```sh
$ sudo apt-get update
$ sudo apt-get install docker-compose
```

or Click [here](https://docs.docker.com/compose/install/) for an eventual particular version.

## Usage of repository

### Get the yocto image (2 different possibilities)
1. Use the already compiled image
```sh
$ docker pull docker.pkg.github.com/roj-italy/docker-roj-demokit/yocto-roj-demokit:0.0.1
```

2. Build the image
- Clone the repository
```sh
$ git clone https://github.com/ROJ-ITALY/Docker-roj-demokit.git
```

- Build the docker image `yocto-roj-demokit`
```sh
$ cd Docker-roj-demokit/
$ ./build.sh
```

### Check the docker yocto image installed
```sh
$ docker images
```
Typical output:

    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    yocto-roj-demokit   0.0.1               46431da0c19b        About a minute ago  998MB
    crops/poky          latest              2b0b585fff62        6 months ago        748MB

### Run docker container
Before runnig the docker container, you need to clone the Yocto Project for roj-demo-kit and create the output yocto directories:
```sh
$ cd ..
$ mkdir Yocto-roj-demokit
$ cd Yocto-roj-demokit
$ git clone --recursive --branch thud https://github.com/ROJ-ITALY/sources.git sources
$ mkdir work
$ mkdir downloads
$ mkdir cache
$ cp ../Docker-roj-demokit/run_work.sh .
$ sudo chmod 755 run_work.sh
```
    
At this point, you can run docker container; use the option -h to print the help:
```sh
$ ./run_work.sh -h
```

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
          
  Below some examples for building u-boot, kernel and core-image-roj in automatic and interactive mode.
  1. Automatic mode:
```sh
    $ ./run_work.sh build uboot imx6qenuc_1gb     --> build u-boot for smarc quad with 1GB of RAM
    $ ./run_work.sh build kernel imx6qenuc_1gb    --> build kernel for smarc quad with 1GB of RAM
    $ ./run_work.sh build image imx6qenuc_1gb     --> build image for smarc quad with 1GB of RAM
```

  2. Interactive mode:
```sh
    $ ./run_work.sh run bash                      --> Init the yocto work dir and run the "bash"
    pokyuser@8dc0c5c9040a:/tmp/work$ bitbake --read=conf/imx6qenuc_1gb.conf u-boot-imx
    pokyuser@8dc0c5c9040a:/tmp/work$ bitbake --read=conf/imx6qenuc_1gb.conf linux-imx
    pokyuser@8dc0c5c9040a:/tmp/work$ bitbake --read=conf/imx6qenuc_1gb.conf core-image-roj
```


