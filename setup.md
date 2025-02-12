# Drone Racing Reinforcement Learning Framework

This repository provides a framework for training control policies for drone racing using reinforcement learning. It integrates the Flightmare simulation environment with ROS 2 Humble and popular reinforcement learning libraries like Stable-Baselines3.

---

## Table of Contents

- [Requirements](#requirements)
  - [System Requirements](#system-requirements)
- [Installation](#installation)
  - [1. Build Docker Container for Flightmare](#1-build-docker-container-for-flightmare)
  - [2. Set Up Flightmare with ROS](#2-set-up-flightmare-with-ros)
  - [3. Set Up Unity with Flightmare](#3-set-up-unity-with-flightmare)
- [Using the Framework](#using-the-framework)
  - [Running the Unity Environment](#running-the-unity-environment)
  - [Running the ROS Environment](#running-the-ros-environment)
  - [Training Policies](#training-policies)
- [Files](#files)
- [Troubleshooting](#troubleshooting)
- [Contributions](#contributions)
- [License](#license)

---

## Requirements

### System Requirements

- Ubuntu Linux
- Docker

---

## Installation

The Flightmare Unity standalone can be run on most Linux environments.

For ROS 1 and TensorFlow integrations, we will create an Ubuntu Docker with the appropriate software versions.

### 1. Build Docker Container for Flightmare

For environments requiring specific versions of TensorFlow 1, CUDA 12, and Python 3.6, follow these steps:

1. **Install Docker:**

   ```bash
   sudo apt update
   sudo apt install docker.io
   ```

2. **Pull Docker Images:**

   You may need to log into NVIDIA.

   ```bash
   docker pull nvcr.io/nvidia/tensorflow:23.01-tf1-py3
   ```

3. **Configure Git:**

   Set up SSH keys and upload them to GitHub:

   ```bash
   sudo apt update
   sudo apt install openssh-client
   ssh-keygen -t rsa -b 4096 -C "yourgithubemail"
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_rsa
   cat ~/.ssh/id_rsa.pub
   ```

   Add the SSH key to your Git provider.

4. **Pull the Flightmare Fork:**

   ```bash
   git clone git@github.com:jhjryu/flightmare_bone.git flightmare
   cd flightmare
   ```

5. **Build the Docker Image:**

   ```bash
   docker build -t fm_tf115_py38 .
   ```

6. **Run the Docker Container:**

   ```bash
   sudo docker run -it --gpus all --network host --device /dev/snd -e DISPLAY=$DISPLAY \
      -v /tmp/.X11-unix:/tmp/.X11-unix --privileged fm_tf115_py38
   ```

7. **Install Dependencies Inside the Container:**

   ```bash
   apt update
   apt install -y git python3-pip python3-venv build-essential
   pip3 install --upgrade pip
   ```

8. **Install and Run VS Code:**

   ```bash
   curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
   mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
   apt update
   apt install -y code
   code . --no-sandbox --user-data-dir /home/flightmare/
   ```

### 2. Set Up Flightmare with ROS

1. **Source ROS:**

   ```bash
   source /opt/ros/noetic/setup.bash
   echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
   source ~/.bashrc
   ```

2. **Clone and Build Flightmare with ROS Support:**

   ```bash
   mkdir -p catkin_ws/src
   cd catkin_ws/src
   git clone git@github.com:jhjryu/flightmare_bone.git flightmare
   vcs-import < flightmare/flightros/dependencies.yaml
   catkin build
   ```

3. **Update Environment Variables:**

   ```bash
   echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
   echo "export FLIGHTMARE_PATH=~/catkin_ws/src/flightmare" >> ~/.bashrc
   source ~/.bashrc
   ```

### 3. Set Up Unity with Flightmare

Download and extract the Unity binary for Flightmare:

```bash
cd ~/flightmare/flightrender
wget https://github.com/uzh-rpg/flightmare/releases/latest/download/RPG_Flightmare.tar.xz
tar -xvf RPG_Flightmare.tar.xz
```

Ensure that the Unity application uses the NVIDIA GPU:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia ./RPG_Flightmare.x86_64
```

---

## Using the Framework

### Running the Unity Environment

Run the Unity application from the local host (outside the Docker):

```bash
cd ~/flightmare/flightrender/RPG_Flightmare
./RPG_Flightmare.x86_64
```

### Running the ROS Environment

To run the ROS environment in the Docker container:

```bash
source ~/catkin_ws/devel/setup.bash
roslaunch flightros rotors_gazebo.launch
```

### Training Policies

To train policies using Stable-Baselines3:

```python
from stable_baselines3 import PPO
from flightmare_env import FlightmareEnv

env = FlightmareEnv()
model = PPO("MlpPolicy", env, verbose=1)
model.learn(total_timesteps=10000)
```

---

## Files

- `setup.sh`: Shell script to set up the environment.
- `requirements.txt`: Python dependencies.
- `FlightmareEnv`: Python wrapper for Flightmare to integrate with Gym.

---

## Troubleshooting

- Ensure ROS is correctly sourced in the terminal.
- Verify the `cmake` and build steps for any errors.
- Check Python library installations with `pip list`.

---

## Contributions

Contributions are welcome! Feel free to submit issues or pull requests to improve this framework.

---

## License

This project is licensed under the MIT License.

