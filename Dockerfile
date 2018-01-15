from ektar/conda-term:v1.0.3

#RUN apt-get update && apt install -qy \
# && rm -rf /var/lib/apt/lists/*

# Install cuda driver 8.0
# Links from https://gist.github.com/mjdietzx/0ff77af5ae60622ce6ed8c4d9b419f45
RUN cd /tmp && \
  wget -O /tmp/cuda-drv.deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb && \
  dpkg -i /tmp/cuda-drv.deb && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends cuda && \
  rm -f /tmp/cuda-drv.deb

# RUN cd /tmp && \
#   wget -O cudnn.tgz http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz && \
#   tar -xvf /tmp/cudnn.tgz -C /usr/local && \
#   rm -f /tmp/cudnn.tgz

# RUN mkdir -p /etc/pki/tls/certs/ && \
#     ln -s /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

COPY jupyter-env.yaml /data/jupyter-env.yaml
RUN /opt/conda/bin/conda env create -f /data/jupyter-env.yaml
RUN npm install -g configurable-http-proxy
#RUN /data/anaconda/envs/jupyterhub/bin/python3 -m ipykernel install  --name juphub-env --display-name "Python (juphub-env)"

RUN openssl genrsa -des3 -passout pass:x -out jupyter.pass.key 2048
RUN openssl rsa -passin pass:x -in jupyter.pass.key -out jupyter.key
RUN openssl req -new -key jupyter.key -out jupyter.csr -batch
RUN openssl x509 -req -days 365 -in jupyter.csr -signkey jupyter.key -out jupyter.crt
RUN mkdir /etc/ssl/jupyter
RUN mv jupyter.* /etc/ssl/jupyter/
COPY jupyterhub_config.py /etc/jupyterhub_config.py

COPY jupyterhub /etc/init.d

# RUN echo 'export PATH=/opt/conda/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/cuda-8.0/bin:/usr/local/sbin:/usr/local/bin:$PATH' >> /etc/profile
# RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> /etc/profile
# RUN LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH ldconfig

# COPY startup.sh /startup.sh

# # RUN mkdir -p /root/.keras
# # RUN echo '{"image_data_format": "channels_last", "epsilon": 1e-07, "floatx": "float32", "backend": "tensorflow"}' > /root/.keras/keras.json

# RUN /opt/conda/bin/pip install --upgrade pip

# # RUN /opt/conda/bin/conda install -y \
# #   dask \
# #   opencv \
# #   patsy \
# #   psycopg2 \
# #   seaborn \
# #   spacy

# # RUN /opt/conda/bin/pip install --upgrade --ignore-installed \
# #   arrow \
# #   flask-restplus \
# #   graphviz \
# #   keras \
# #   os_client_config \
# #   pydicom \
# #   pymc3 \
# #   pymongo \
# #   python-openstackclient \
# #   sacred \
# #   tensorflow-gpu \
# #   xgboost

# # Add the good python 3.x to jupyter
# COPY python3-dl-env.yaml /data/python3-dl-env.yaml
# RUN /data/anaconda/bin/conda env create -f /data/python3-dl-env.yaml

# RUN /data/anaconda/envs/python3-dl/bin/python3 -m ipykernel install --name python3-dl --display-name "Python 3.6 (python3-dl)"
