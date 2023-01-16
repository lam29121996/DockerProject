FROM gpuci/miniconda-cuda:11.4-devel-ubuntu20.04
EXPOSE 8000

WORKDIR /suitcase_ReID

COPY deep-person-reid ./deep-person-reid/
COPY multi-object-tracker ./multi-object-tracker/

RUN conda create -n my_env python=3.8 \
    && apt-get update \
    && apt-get install -y apt-utils \
    # For mongodb
    && apt-get install -y mongodb \
    # For cv2
    && apt-get install -y libgl1-mesa-glx \
    && apt-get install -y libglib2.0-0 \
    && conda run -n my_env apt install -y libsm6 libxext6 \
    && conda run -n my_env apt install -y libfontconfig1 libxrender1 \
    # Breakdown of setep.sh
    && cd deep-person-reid \
    && conda run -n my_env pip install -r requirements.txt \
    && conda install -n my_env pytorch torchvision -c pytorch \
    && conda run -n my_env python setup.py develop \
    && cd .. \
    && conda run -n my_env pip install -qr https://raw.githubusercontent.com/ultralytics/yolov5/master/requirements.txt \
    && cd multi-object-tracker \
    && conda run -n my_env pip install -r requirements.txt \
    && conda run -n my_env pip install -e . \
    && cd .. \
    && conda run -n my_env pip install ipyfilechooser \
                                       scipy \
                                       pyyaml \
                                       pymongo \
                                       fastapi \
                                       uvicorn \
                                       easydict \
                                       scikit-image \
                                       python-multipart

# For QT debug
ENV QT_DEBUG_PLUGINS=1

# The code to run when container is started:
CMD nvidia-smi && \
    service mongodb start & \
    conda run --no-capture-output -n my_env python main.py & \
    conda run --no-capture-output -n my_env uvicorn --host 0.0.0.0 app:app
