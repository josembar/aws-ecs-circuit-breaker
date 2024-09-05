#!/bin/bash

delete_image() {
    image=$(docker images $1 -q)
    if [ -z $image ]
    then
        echo "Image $1 not found"
    else
        docker image rm $image
    fi
}

ecr_login () {
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
}

build_and_push_image() {
    image_name=$1
    directory=$2
    ecr_repo_name=$3
    docker build -t $image_name $directory
    docker tag $image_name:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ecr_repo_name:$image_name-latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ecr_repo_name:$image_name-latest
}

# AWS_REGION=$1
# echo "AWS_REGION $AWS_REGION"

# AWS_ACCOUNT_ID=$2
# echo "AWS_ACCOUNT_ID $AWS_ACCOUNT_ID"

# NODEJS_APP_IMAGE_NAME=$3
# echo "NODEJS_APP_IMAGE_NAME $NODEJS_APP_IMAGE_NAME"

# JAVA_APP_IMAGE_NAME=$4
# echo "JAVA_APP_IMAGE_NAME $JAVA_APP_IMAGE_NAME"

# NODEJS_ECR_REPO_NAME=$5
# echo "ECR_REPO_NAME $ECR_REPO_NAME"

# JAVA_ECR_REPO_NAME=$6
# echo "ECR_REPO_NAME $ECR_REPO_NAME"

# images=("$NODEJS_APP_IMAGE_NAME" "$JAVA_APP_IMAGE_NAME")
images=("nodeapp" "javaapp")
for image in ${images[@]}; do
    delete_image $image
done

# cd ../

# # # docker build -t $IMAGE_NAME ../app
# docker build -t $DEMO_APP_IMAGE_NAME ../app

# docker build -t $OTEL_IMAGE_NAME ./otel

# docker build -t $THANOS_IMAGE_NAME ./thanos

# aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# # # docker tag $IMAGE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME
# docker tag $DEMO_APP_IMAGE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$DEMO_APP_IMAGE_NAME-latest

# docker tag $OTEL_IMAGE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$OTEL_IMAGE_NAME-latest

# docker tag $THANOS_IMAGE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$THANOS_IMAGE_NAME-latest

# # # docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME
# docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$DEMO_APP_IMAGE_NAME-latest

# docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$OTEL_IMAGE_NAME-latest

# docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$THANOS_IMAGE_NAME-latest