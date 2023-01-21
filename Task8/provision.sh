# Create S3 source bucket
aws s3api create-bucket \
    --bucket slavychlab8 \
    --region us-east-1  

# Create S3 destination bucket
aws s3api create-bucket \
    --bucket slavychlab8-resized \
    --region us-east-1  

# Put an object to source bucket
aws s3api put-object --bucket slavychlab8 --key image.jpg --body image.jpg

# Create Lambda Policy
POLICY_ARN=`aws iam create-policy --policy-name AWSLambdaS3Policy --policy-document file://lambda_policy.json --query Policy.Arn --output text`

# Create Lambda execution role 
aws iam create-role \
    --role-name lambda-s3-role \
    --assume-role-policy-document file://trust-policy.json

# Attach a Policy
aws iam attach-role-policy \
    --policy-arn $POLICY_ARN \
    --role-name lambda-s3-role

# Build the deployment package
sam build --use-container

# Create the Lambda function
sam deploy --guided

# Retrieve function name
FUNC_NAME=`aws lambda list-functions --query Functions[0].FunctionName --output text`

# Add timeout
aws lambda update-function-configuration --function-name $FUNC_NAME --timeout 30

# Invoke the function
aws lambda invoke \
    --function-name $FUNC_NAME \
    --cli-binary-format raw-in-base64-out \
    --invocation-type Event \
    --payload file://inputFile.txt outputfile.txt

# Configure Amazon S3 to publish events
aws lambda add-permission \
    --function-name $FUNC_NAME \
    --principal s3.amazonaws.com \
    --statement-id s3invoke \
    --action "lambda:InvokeFunction" \
    --source-arn arn:aws:s3:::slavychlab8 \
    --source-account 266132757975

# Verify the function's access policy
aws lambda get-policy --function-name $FUNC_NAME

FUNC_ARN=`aws lambda list-functions --query 'Functions[0].FunctionArn' --output text`

echo '{
    "LambdaFunctionConfigurations": [
        {
            "Id": "lambda-trigger",
            "LambdaFunctionArn": "'"$FUNC_ARN"'" ,
            "Events": [
                "s3:ObjectCreated:*"
            ]
        }
    ]
}' > notification.json

aws s3api put-bucket-notification-configuration --bucket slavychlab8 --notification-configuration file://notification.json