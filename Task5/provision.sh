# Create SNS topic
TOPIC_ARN=`aws sns create-topic --name health_checking --query 'TopicArn' --output text`

TARGET_GROUP_ID="targetgroup/TargetGroupLab4/f282e53098788eef"
LB_ID="app/my-load-balancer/8ece4b01f3db1ad5"

# Subscribe SNS topic
SUB_ARN=`aws sns subscribe \
    --topic-arn $TOPIC_ARN \
    --protocol email \
    --notification-endpoint alexseeko15@gmail.com \
    --query 'SubscriptionArn' --output text`

# Set up a cloudwatch
aws cloudwatch put-metric-alarm \
    --alarm-name health_checking \
    --alarm-description "Instance is deleted!" \
    --metric-name HealthyHostCount \
    --namespace AWS/ApplicationELB \
    --statistic Average \
    --period 60 \
    --threshold 2 \
    --comparison-operator LessThanThreshold \
    --dimensions Name=TargetGroup,Value=$TARGET_GROUP_ID Name=LoadBalancer,Value=$LB_ID \
    --evaluation-periods 1 \
    --alarm-actions $TOPIC_ARN