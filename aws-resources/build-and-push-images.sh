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

AWS_REGION=$1
AWS_ACCOUNT_ID=$2
NODEJS_APP_IMAGE_NAME=$3
JAVA_APP_IMAGE_NAME=$4
NODEJS_ECR_REPO_NAME=$5
JAVA_ECR_REPO_NAME=$6

# Declare an associative array
declare -A nodejs_image
# Add elements to the associative array
nodejs_image[name]="nodejsapp"
nodejs_image[directory]="./app/node.js/nodeapp"
nodejs_image[ecr_repo_name]="circuit-breaker-demo-nodejs"

declare -A java_image
java_image[name]="javaapp"
java_image[directory]="./app/java/javaapp"
java_image[ecr_repo_name]="circuit-breaker-demo-java"

declare -a image_names
image_names+=( ${nodejs_image[name]} ${java_image[name]})
echo "Deleting images if they're found..."
for image in ${image_names[@]}; do
    delete_image $image
done

cd ../

echo "AWS_REGION $AWS_REGION"
echo "AWS_ACCOUNT_ID $AWS_ACCOUNT_ID"
echo "NODEJS_APP_IMAGE_NAME $NODEJS_APP_IMAGE_NAME"
echo "JAVA_APP_IMAGE_NAME $JAVA_APP_IMAGE_NAME"
echo "NODEJS_ECR_REPO_NAME $NODEJS_ECR_REPO_NAME"
echo "JAVA_ECR_REPO_NAME $JAVA_ECR_REPO_NAME"

#ecr_login

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