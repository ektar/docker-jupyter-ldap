#!/usr/bin/env bash

PATH=/opt/conda/envs/jupyterhub/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
CONDA_ENV_PATH=/opt/conda/envs/jupyterhub \
CONDA_DEFAULT_ENV=jupyterhub \
nohup /opt/conda/envs/jupyterhub/bin/jupyterhub -f /etc/jupyterhub_config.py &

/data/startup.sh
