## Pose  Estimation  from  RGB  Images  of  Highly  Symmetric  Objects using  a  Novel  Multi-Pose  Loss  and  Differential  Rendering

## Overview

Pending...

<p align="center">
<img src='docs/overview.svg' width='800'>
<p>

## Setup

1) Install docker and setup nvidia runtime environment.
   - Install nvidia-docker2
     (see https://gist.github.com/Brainiarc7/a8ab5f89494d053003454efc3be2d2ef)

   - Add "nvidia" as default runtime to build Docker image with CUDA support. Required for pytorch3d. (see https://stackoverflow.com/questions/59691207/docker-build-with-nvidia-runtime)

2) Build docker image(s)

  - Clone this repo:
   ```
   git clone git@github.com:shbe-aau/multi-pose-estimation.git
   ```


   - Run `bash build.sh` in `dockerfiles/pytorch3d` to build the Docker images.
   - (Optional) Run `bash build.sh` in `dockerfiles/aae` to build the Docker image for running the AAE (Augmented Autoencoder) - this is only needed for evaluation of the AAE approach.

Tested working on Ubuntu 16.04 LTS with Docker 18.09.7 and NVIDIA docker 2.3.0, and on Ubuntu 16.04 LTS with Docker 19.03.4 and NVIDIA docker 2.3.0.

Already built images can be found at: pending

## Prepare models and data

1) Download background images by executing the script 'download-voc2012.sh' in 'multi-pose/data/VOC2012'. We use the VOC2012 devkit for background images, they can also be found at http://host.robots.ox.ac.uk/pascal/VOC/voc2012/#devkit

2) (Optional) Use the default for the T-LESS dataset already provided in `multi-pose/data/cad-files` or place your own CAD files in this folder.

3) (Optional) Prepare the encoder weights. You have the following options:

  a. Use the default pretrained encoder weights already provided in 'multi-pose/data/encoder/obj1-18/encoder.npy'

  b. Get the [pretrained encoder](https://dlrmax.dlr.de/get/b42e7289-7558-5da0-8f26-4c472ad830a9/) as provided from the [AAE repo](https://github.com/DLR-RM/AugmentedAutoencoder/tree/multipath).

  c. Train your own autoencoder as specified in the [AAE repo](https://github.com/DLR-RM/AugmentedAutoencoder/tree/multipath).

4) (Optional - only necessary for option __3b__ or __3c__) Convert the trained encoder from Tensorflow to Pytorch format.
   - Instructions will be added later.

## Train

1) (Optional) Update the default path for the shared folder in `dockerfile/pytorch3d/run-gpu0.sh` - the shared folder should include the cloned repo. The default shared folder is `~/share-to-docker`. This step is only necessary if you did not clone the repo to the default location.

2) Spin up the Docker container and start training:
   ```
   bash dockerfiles/pytorch3d/run-gpu0.sh
   cd shared-folder/multi-pose
   python train.py experiment_template.cfg
   ```
   Parameters for the training are set in the .cfg file found in 'multi-pose/experiments' folder. You can create new configurations files for each training session.

   The output of the training is saved at the path specified by the 'OUTPUT_PATH' parameter in the .cfg file. The default is './output/test' for 'experiment_template.cfg'. (__NOTE:__ Remember to specify different output paths for different sessions of training or you may overwrite previous training sessions!)


### Evaluating

1) Download the T-LESS __'BOP'19/20 test images'__ and __'Object models'__ from https://bop.felk.cvut.cz/datasets/ by running: 'bash download-tless.sh' in 'multi-pose/data/tless/'

2) Run the evaluation script:
   ```
   bash ~/share-to-docker/multi-pose-estimation/multi-pose/scripts/run-eval.sh \
   OBJ_ID \
   APPROACH_NAME \
   TRAINED_MODEL \
   DATA_SPLIT \
   DATASET
   ```
   Example - evaluating the first epoch from the 'experiment_template.cfg' run:
   ```
   bash ~/share-to-docker/multi-pose-estimation/multi-pose/scripts/run-eval.sh \
   10 \
   "experiment-template-epoch0" \
   "multi-pose/output/test/models/model-epoch0.pt" \
   "test" \
   "tless"
   ```
   __NOTE:__ Do not use '_' for the APPROACH_NAME as it messes with evaluation scripts.

4) The output of the evaluation can be found in 'multi-pose/data/tless/test-primesense/OBJ_ID/eval'.

## Visualize loss landscape

To visualize a loss landscape you can use the same config file as for training. Parameters under `[Sampling]` set number of points on a sphere to try, and which of those poses to treat as groundtruth (by index).

Determine poses and losses by running `plot_loss_landscape.py` in the docker container, and produce and view the final plots by running `show_loss_landscape.py`. You might want to run the second outside the docker to interact with the plots.
