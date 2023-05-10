#!/bin/bash

BUCKET="slavychlab1"

aws s3api create-bucket --bucket $BUCKET --region us-east-1     

aws s3api delete-public-access-block --bucket $BUCKET

aws s3api put-bucket-policy --bucket $BUCKET --policy file://policy.json         

aws s3 sync ./ s3://$BUCKET/                                                             

aws s3 website s3://$BUCKET/ --index-document index.html --error-document error.html

#website url: http://slavychlab1.s3-website-us-east-1.amazonaws.com/