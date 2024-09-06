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

declare -a nodejs_image
nodejs_image+=( "nodejsapp" "./app/node.js/nodeapp" "circuit-breaker-demo-nodejs" )
declare -a java_image
java_image+=( "javaapp" "./app/java/javaapp" "circuit-breaker-demo-java" )
declare -A images
images[0]=${nodejs_image[@]}
images[1]=${java_image[@]}

echo "Deleting images if they're found..."
for i in "${!images[@]}"; do 
  elements=(${images[$i]})
  delete_image ${elements[0]}
done

cd ../

echo "AWS_REGION $AWS_REGION"
echo "AWS_ACCOUNT_ID $AWS_ACCOUNT_ID"
echo "NODEJS_APP_IMAGE_NAME $NODEJS_APP_IMAGE_NAME"
echo "JAVA_APP_IMAGE_NAME $JAVA_APP_IMAGE_NAME"
echo "NODEJS_ECR_REPO_NAME $NODEJS_ECR_REPO_NAME"
echo "JAVA_ECR_REPO_NAME $JAVA_ECR_REPO_NAME"

ecr_login

echo "Building and pushing images to ECR..."
for i in "${!images[@]}"; do 
  elements=(${images[$i]})
  build_and_push_image ${elements[0]} ${elements[1]} ${elements[2]}
done