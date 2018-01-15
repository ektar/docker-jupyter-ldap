#!/usr/bin/env bash

cd /data
service ssh start
PATH=/data/anaconda/envs/jupyterhub/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
CONDA_ENV_PATH=/data/anaconda/envs/jupyterhub \
CONDA_DEFAULT_ENV=jupyterhub \
nohup /data/anaconda/envs/jupyterhub/bin/jupyterhub -f /etc/jupyterhub_config.py
