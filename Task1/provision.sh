#!/bin/bash

aws s3api create-bucket --bucket slavychlab1 --region us-east-1                              

aws s3api put-bucket-policy --bucket slavychlab1 --policy file://policy.json         

aws s3 sync ./ s3://slavychlab1/                                                             

aws s3 website s3://slavychlab1/ --index-document index.html --error-document error.html

#website url: http://slavychlab1.s3-website-us-east-1.amazonaws.com/