docker run -ti --rm --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 --user=$( id -u $USER ):$( id -g $USER ) --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" -v ~/vision:/shared-folder -e DISPLAY=$DISPLAY --env QT_X11_NO_MITSHM=1 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" pytorch3d_multiview_pose
