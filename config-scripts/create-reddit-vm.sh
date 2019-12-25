#!/bin/bash
gcloud compute instances create reddit-app --zone=europe-west3-a --machine-type=f1-micro --tags=puma-server --image=reddit-full-1577267660 --image-project=infra-262405 --restart-on-failure
