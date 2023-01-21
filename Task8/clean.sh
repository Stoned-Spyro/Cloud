# Delete stack
aws cloudformation delete-stack --stack-name sam-app

# Delete a Role
aws iam delete-role --role-name lambda-s3-role

# Clearing source bucket
aws s3 rm s3://slavychlab8 --recursive

# Clearing destination bucket
aws s3 rm s3://slavychlab8-resized --recursive

# Remove source bucket
aws s3 rb s3://slavychlab8

# Remove destination bucket
aws s3 rb s3://slavychlab8-resized
