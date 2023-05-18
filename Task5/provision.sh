# Create SNS topic
TOPIC_ARN=`aws sns create-topic --name load_balancer_health --query 'TopicArn' --output text`

# Subscribe SNS topic
SUB_ARN=`aws sns subscribe \
    --topic-arn $TOPIC_ARN \
    --protocol email \
    --notification-endpoint alexseeko15@gmail.com \
    --query 'SubscriptionArn' --output text`

# Set up a cloudwatch
aws cloudwatch put-metric-alarm \
    --alarm-name ELBHealth \
    --alarm-description "Instance is deleted!" \
    --metric-name HealthyHostCount \
    --namespace AWS/ApplicationELB \
    --statistic Average \
    --period 60 \
    --threshold 2 \
    --comparison-operator LessThanThreshold \
    --dimensions Name=TargetGroup,Value=targetgroup/TargetGroupForLab4/516e1598de83b0e7 Name=LoadBalancer,Value=app/my-load-balancer/af9ce62f5650eba7 \
    --evaluation-periods 1 \
    --alarm-actions $TOPIC_ARN

