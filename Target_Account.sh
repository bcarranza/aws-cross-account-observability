# Create an s3 bucket to store log file about Kinesis firehouse
aws s3api create-bucket --bucket firehose-test-bucket1 --create-bucket-configuration LocationConstraint=us-west-2

# Create the IAM role, specifying the trust policy file that you just made.
aws iam create-role \ 
    --role-name FirehosetoS3Role \ 
    --assume-role-policy-document file://~/TrustPolicyForFirehose.json

# Enter the following command to associate the permissions policy that you just created with the IAM role.
aws iam put-role-policy --role-name FirehosetoS3Role --policy-name Permissions-Policy-For-Firehose-To-S3 --policy-document file://~/PermissionsForFirehose.json

# Enter the following command to create the Kinesis Data Firehose delivery stream. Replace my-role-arn and my-bucket-arn with the correct values for your deployment.
aws firehose create-delivery-stream \
   --delivery-stream-name 'my-delivery-stream' \
   --s3-destination-configuration \
  '{"RoleARN": "arn:aws:iam::222222222222:role/FirehosetoS3Role", "BucketARN": "arn:aws:s3:::firehose-test-bucket1"}'

# Wait until the Kinesis Data Firehose stream that you created in Step 1: Create a Kinesis Data Firehose delivery stream becomes active. You can use the following command to check the StreamDescription.StreamStatus property.
aws firehose describe-delivery-stream --delivery-stream-name "my-delivery-stream"


# Use the aws iam create-role command to create the IAM role, specifying the trust policy file that you just created. 
aws iam create-role \
      --role-name CWLtoKinesisFirehoseRole \
      --assume-role-policy-document file://~/TrustPolicyForCWL.json

# Associate the permissions policy with the role by entering the following command:
aws iam put-role-policy --role-name CWLtoKinesisFirehoseRole --policy-name Permissions-Policy-For-CWL --policy-document file://~/PermissionsForCWL.json

# This creates a policy that defines who has write access to the destination. This policy must specify the logs:PutSubscriptionFilter action to access the destination. Cross-account users will use the PutSubscriptionFilter action to send log events to the destination:
aws logs put-destination-policy \
    --destination-name "testFirehoseDestination" \
    --access-policy file://~/AccessPolicy.json


