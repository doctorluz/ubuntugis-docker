FROM ubuntu:14.04

# Connect to ubuntugis

RUN echo "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu precise main " >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu precise main " >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 314DF160

RUN echo "deb http://ppa.launchpad.net/grass/grass-devel/ubuntu precise main " >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/grass/grass-devel/ubuntu precise main " >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 26D57B27

#RUN apt-get install python-software-properties
#RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable

# update apt cache and upgrade
RUN apt-get update
RUN apt-get upgrade -y

# Install Utilities
RUN apt-get install -y curl git mc build-essential python-setuptools python-dev python-pip python-software-properties python-numpy python-scipy libgdal-dev python-gdal gdal-bin libproj0 libproj-dev python-pyproj libgeos-3.4.2 libgeos-dev nano wget git dialog

RUN pip install scikit-learn

# Java
RUN apt-get install -y default-jre 

# GRASS GIS 7

RUN apt-get install -y grass71