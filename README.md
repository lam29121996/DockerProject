## Docker 101
dockerfile ----[docker build]---> image ----[docker run]---> container


## AppTech_Suitcase_ReID


### Before run this program, you should:
* Make sure that Docker is installed
    * - [x] Docker (version 20.10.8)
* Make sure that cuda & cudnn can be used in container
    * - [x] Driver for GPU on host (version 470.103.01)
    * - [x] CUDA for GPU on host (version 11.4)
    * - [x] nvidia-container-toolkit on host
* Make sure the completeness of the folder
    * - [x] /suitcase_ReID_yyyymmdd


### To run this program, you may use:
```
$ docker run --rm -it --gpus all -p 8000:8000 -v ~/vma/suitcase_ReID_20220207:/suitcase_ReID -v /tmp/.X11-unix:/tmp/.X11-unix -v $XAUTHORITY:/tmp/.XAuthority -e DISPLAY=$DISPLAY -e XAUTHORITY=/tmp/.XAuthority --env="QT_X11_NO_MITSHM=1" my_image:11.4-devel-ubuntu20.04
```
This will run
* `nvidia-smi` (to check GPU driver version, CUDA version)

first and run

* `mongodb`
* `app.py`
* `main.py`

simultaneously.

p.s. These may change depends on setting, file_path, file_name, etc.
* `--rm`
* `--gpus all`
* `-p 8000:8000`
* `-v ~/vma/suitcase_ReID_20220207:/suitcase_ReID`
* `my_image:11.4-devel-ubuntu20.04`

Rest of it are very unlikely to change.


### Options of `docker run` command:

    $ docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

`--rm`    : Automatically remove the container when it exits

`--i`     : Keep STDIN open even if not attached

`--t`     : Allocate a pseudo-TTY

`--gpus`  : GPU devices to add to the container ('all' to pass all GPUs)

`-p`      : Publish a container's port(s) to the host

`-v`      : Bind mount a volume

`-e`      : Set environment variables


### `docker run` command sample:
```
$ docker run 
    --rm 
    -it 
    --gpus <all / device=device_ID / device=0,2>
    -p <host_port:container_port>
    -v <host_src:container_dest>
    -e <environment variables>
    <image_name>:<image_tag>
    <command>
```

## Important
### You should limit the version of `opencv-python` & `opencv-contrib-python`, which already did for you.
To limit the version of `opencv-python`, modify `./suitcase_ReID_yyyymmdd/deep-person-reid/requirements.txt`
    
    opencv-python==4.2.0.32

To limit the version of `opencv-contrib-python`, modify `./suitcase_ReID_yyyymmdd/multi-object-tracker/requirements.txt`

    opencv-contrib-python==4.1.2.30


## Debug
add `/bin/bash` as the specified command in `docker run` command

    $ docker run [OPTIONS] IMAGE /bin/bash [ARG...]

which will overwrite the default command by `/bin/bash` , in short,  will enter `bash` rather than run `nvidia-smi`, `mongodb`, `app.py` & `main.py` automatically.


### Command to run different services in container:
Run `nvidia-smi`

    $ nvidia-smi

Run `mongodb`

    $ service mongodb start

Run `main.py` in conda environment

    $ conda run --no-capture-output -n my_env python main.py

Run `app.py` in conda environment

    $ conda run --no-capture-output -n my_env uvicorn --host 0.0.0.0 app:app


## Common Docker command line on host
Remove unused data

    $ docker system prune

Build an image from a Dockerfile

    $ ./docker build -t <image_name:image_tag> . --no-cache

Save one or more images to a tar archive (streamed to STDOUT by default)

    $ docker save -o my_image.tar my_image

Load an image from a tar archive or STDIN

    $ docker load -i my_image.tar
