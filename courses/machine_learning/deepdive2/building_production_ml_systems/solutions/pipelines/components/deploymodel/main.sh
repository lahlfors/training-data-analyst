#!/bin/bash


BUCKET=laah-buzz-bucket
REGION=us-central1
MODEL_NAME=taxifare
VERSION_NAME=dnn

GCS_PROJECT_PATH=gs://$BUCKET/taxifare
OUTPUT_DIR=$GCS_PROJECT_PATH/model
PROJECT_ID=$(gcloud config list project --format "value(core.project)")
EXPORT_PATH=$(gsutil ls $OUTPUT_DIR/export/savedmodel | tail -1)


#if [[ $(gcloud ai-platform models list --region=$REGION --format='value(name)' | grep $MODEL_NAME) ]]; then
#    echo "$MODEL_NAME already exists"
#else
echo "Creating $MODEL_NAME"
gcloud ai-platform models create --region=$REGION $MODEL_NAME
#fi

#if [[ $(gcloud ai-platform versions list --model $MODEL_NAME --region $REGION --format='value(name)' | grep $VERSION_NAME) ]]; then
#    echo "Deleting already existing $MODEL_NAME:$VERSION_NAME ... "
#    echo yes | gcloud ai-platform versions delete --model=$MODEL_NAME $VERSION_NAME
#    sleep 2
#fi

echo "Creating $MODEL_NAME:$VERSION_NAME"
# --async \
gcloud ai-platform versions create --model=$MODEL_NAME $VERSION_NAME \
     --framework=tensorflow \
     --python-version=3.5 \
     --runtime-version=1.14 \
     --origin=$EXPORT_PATH \
     --staging-bucket=gs://$BUCKET