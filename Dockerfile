FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive 

# Installing some essential system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
   lsb-release \
   build-essential \
   python3 python3-dev python3-pip \
   cmake \
   git \
   vim \
   ca-certificates \
   libzmqpp-dev \
   libopencv-dev \
   gnupg2 \
   && rm -rf /var/lib/apt/lists/*

# Install a newer version of CMake
# Update and install system dependencies, including wget
RUN apt-get update && apt-get install -y \
    wget \
    software-properties-common \
    build-essential \
    libssl-dev

RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3-linux-x86_64.sh && \
    chmod +x cmake-3.24.3-linux-x86_64.sh && \
    ./cmake-3.24.3-linux-x86_64.sh --prefix=/usr/local --skip-license && \
    rm cmake-3.24.3-linux-x86_64.sh

# python 
# Install Python 3.6 and set it as default for both python3 and python
RUN apt-get update && apt-get install -y \
    python3.6 \
    python3.6-dev \
    python3.6-distutils \
    python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 && \
    update-alternatives --set python3 /usr/bin/python3.6 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
    update-alternatives --set python /usr/bin/python3.6 && \
    apt-get clean

# Ensure pip is updated for Python 3.8
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# Upgrade pip and install necessary build tools
RUN pip3 install --upgrade pip setuptools wheel scikit-build

RUN /bin/bash -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 

# Installing ROS  Melodic
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-melodic-desktop-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing catkin tools
RUN apt-get update && apt-get install -y python3-setuptools && pip3 install catkin-tools 

# Clone Flightmare repository and set the FLIGHTMARE_PATH environment variable
RUN git clone https://github.com/jhjryu/flightmare_bone.git /home/flightmare && \
    echo "export FLIGHTMARE_PATH=/home/flightmare" >> /etc/bash.bashrc

ENV FLIGHTMARE_PATH=/home/flightmare

# Install Python dependencies for Flightmare
RUN pip3 install /home/flightmare/flightlib && \
    pip3 install /home/flightmare/flightrl

# Verify CMake version
RUN cmake --version

# Install Python dependencies for Flightmare
RUN pip3 install --upgrade pip setuptools wheel scikit-build &&\
    pip3 install /home/flightmare/flightlib && \
    pip3 install /home/flightmare/flightrl

