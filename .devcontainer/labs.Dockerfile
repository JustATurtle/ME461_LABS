FROM osrf/ros:humble-desktop-full

# Setup User information 
ARG USERNAME=me461
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Default values for installion prompts
ARG DEBIAN_FRONTEND=noninteractive

# Setup shell environment
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

# Install General Dependencies
RUN apt update; apt install build-essential \
    sudo \
    -y nano \
    software-properties-common \
    autoconf \
    -y git \
    curl \
    wget \
    -y libx11-dev \
    cmake \
    neovim \
    highlight \
    htop \
    galculator \
    -y iputils-ping \
    -y zsh \
    python3-pip 

# Install ROS packages
RUN apt install ros-humble-cv-bridge -y \
    ros-humble-gazebo-* -y \
    ros-humble-turtlebot3* -y \
    ros-humble-teleop-twist-keyboard -y \
    ros-humble-joint-state-publisher* -y \
    ros-humble-robot-state-publisher* -y \
    && rm -rf /var/lib/apt/lists/*

# Add user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN usermod -aG dialout ${USERNAME}

USER $USERNAME

# Install necessary python packages
RUN pip install --user --upgrade numpy; \
    pip install --user --upgrade matplotlib; \
    pip install --user --upgrade opencv-python; \
    pip install --user --upgrade scikit-image; \
    pip install --user --upgrade scikit-learn; \
    pip install --user --upgrade scipy; \
    pip install --user --upgrade pandas; \
    pip install --user --upgrade plotly; \
    pip install --user --upgrade mediapipe; 

#Setup ROS2 & Gazebo Environment
# RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
# RUN echo "source /usr/share/gazebo/setup.bash" >> ~/.bashrc
# RUN echo "export TURTLEBOT3_MODEL=waffle" >> ~/.bashrc
# RUN echo "export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/humble/share/turtlebot3_gazebo/models" >> ~/.bashrc
