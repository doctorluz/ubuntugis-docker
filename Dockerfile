FROM ubuntu:14.04

# Connect to ubuntugis and R latest

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/  " >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu trusty main " >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu trusty main " >> /etc/apt/sources.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 314DF160

COPY ./key /tmp/key
COPY ./key2 /tmp/key2

RUN apt-key add /tmp/key
RUN apt-key add /tmp/key2

RUN echo "deb http://ppa.launchpad.net/grass/grass-devel/ubuntu trusty main " >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/grass/grass-devel/ubuntu trusty main " >> /etc/apt/sources.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 26D57B27

# update apt cache and upgrade
RUN apt-get update
RUN apt-get upgrade -y

# Install Utilities

#RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

RUN apt-get install -y --force-yes build-essential language-pack-en* 
RUN apt-get install -y --force-yes build-essential curl
RUN apt-get install -y --force-yes build-essential iputils-ping
RUN apt-get install -y --force-yes build-essential fuse
RUN apt-get install -y --force-yes build-essential libfuse-dev libfuse2
RUN apt-get install -y --force-yes build-essential git
RUN apt-get install -y --force-yes build-essential mc
RUN apt-get install -y --force-yes build-essential sshfs
RUN apt-get install -y --force-yes build-essential python-setuptools
RUN apt-get install -y --force-yes build-essential python-dev
RUN apt-get install -y --force-yes build-essential libpython-dev
RUN apt-get install -y --force-yes build-essential python-pip
RUN apt-get install -y --force-yes build-essential software-properties-common
RUN apt-get install -y --force-yes build-essential python-numpy
RUN apt-get install -y --force-yes build-essential libgdal-dev
RUN apt-get install -y --force-yes build-essential python-gdal
RUN apt-get install -y --force-yes build-essential gdal-bin
RUN apt-get install -y --force-yes build-essential libproj0
RUN apt-get install -y --force-yes build-essential libproj-dev
RUN apt-get install -y --force-yes build-essential python-pyproj
RUN apt-get install -y --force-yes build-essential libgeos-*
RUN apt-get install -y --force-yes build-essential nano
RUN apt-get install -y --force-yes build-essential wget
RUN apt-get install -y --force-yes build-essential dialog
RUN apt-get install -y --force-yes build-essential libgdal1-dev
RUN apt-get install -y --force-yes build-essential libgdal1h 
RUN apt-get install -y --force-yes build-essential grass-core 
RUN apt-get install -y --force-yes build-essential python-matplotlib 
RUN apt-get install -y --force-yes build-essential python-pandas 
RUN apt-get install -y --force-yes build-essential python-sympy 
RUN apt-get install -y --force-yes build-essential python-scipy 
RUN apt-get install -y --force-yes build-essential python-nose 
RUN apt-get install -y --force-yes build-essential libblas-dev 
RUN apt-get install -y --force-yes build-essential liblapack-dev 
RUN apt-get install -y --force-yes build-essential gfortran 
RUN apt-get install -y --force-yes build-essential ipython 
RUN apt-get install -y --force-yes build-essential ipython-notebook

#RUN pip install ipython ipython-notebook --upgrade
RUN pip install scikit-learn #--upgrade
#RUN pip install numpy --upgrade
#RUN pip install scipy --upgrade
#RUN pip install gdal --upgrade

# Lucy testing
#RUN sudo apt-get install libxml2-dev libxslt1-dev
#pip install lxml --upgrade
#RUN pip install scrapy
# end Lucy testing

# Java
RUN apt-get install -y default-jre-headless default-jre 

# GRASS GIS 7 and R

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 

RUN apt-get install -y --force-yes flex firefox openssh-server bison libtiff4-dev mesa-common-dev libglu-dev  libfftw3-* libcairo2-dev python-gtk2 python-gtk2-dbg python-gtk2-dev python-wxgtk* grass70-* r-base r-base-dev r-cran-xml libapparmor1 gdebi-core xserver-xorg xdm xterm gedit-plugins

# Configuring xdm to allow connections from any IP address and ssh to allow X11 Forwarding.
RUN sed -i 's/DisplayManager.requestPort/!DisplayManager.requestPort/g' /etc/X11/xdm/xdm-config
RUN sed -i '/#any host/c\*' /etc/X11/xdm/Xaccess
#RUN ln -s /usr/bin/Xorg /usr/bin/X 
# not working

RUN echo "local({r <- getOption('repos');r['CRAN'] <- 'http://cran.rstudio.com/';options(repos = r)})" > /etc/R/Rprofile.site

# ipython notebook
RUN apt-get update && apt-get install -y -q \
    make \
    gcc \
    zlib1g-dev \
    python \
    python-sphinx \
    python3-sphinx \
    libzmq3-dev \
    sqlite3 \
    libsqlite3-dev \
    pandoc \
    libcurl4-openssl-dev \
    nodejs \
    nodejs-legacy

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y software-properties-common 
RUN apt-get install -y vnc4server vncviewer pgadmin3 postgis

RUN add-apt-repository -y ppa:opencpu/opencpu-1.5
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y opencpu

RUN pip install rpy2

RUN wget http://download.savannah.gnu.org/releases/pktools/install_pktools.sh

RUN bash install_pktools.sh 

RUN echo LANG="en_US.UTF-8" > /etc/default/locale
COPY ./sshd /etc/pam.d/sshd
COPY ./ssh_config /etc/ssh/ssh_config

RUN Rscript -e "install.packages('XML', type = 'source');install.packages(c('devtools','png','rgdal','raster','yaml','base64enc'));devtools::install_github('ramnathv/rCharts@dev');devtools::install_github('ramnathv/rMaps');devtools::install_github('javimarlop/ocpu-radarplot-sochi')"

#RUN echo X11Forwarding yes >> /etc/ssh/ssh_config # not working

-RUN useradd -M lucy
-RUN echo 'lucy:docker.io' | chpasswd
-RUN usermod -s /bin/bash lucy
-RUN adduser lucy sudo

EXPOSE 22
EXPOSE 8888
EXPOSE 80
EXPOSE 443
EXPOSE 8006
EXPOSE 8007

RUN mkdir /var/run/sshd

RUN /etc/init.d/xdm restart
#RUN service ssh restart
#CMD service opencpu restart && tail -F /var/log/opencpu/apache_access.log


