import json
import boto3
import os
from datetime import datetime

def handler(event, context):
    """
    Lambda function handler for ${{ values.name }}
    
    This function demonstrates integration with S3 and provides
    basic functionality for the infrastructure stack.
    """
    
    # Get environment variables
    s3_bucket = os.environ.get('S3_BUCKET')
    project_name = os.environ.get('PROJECT_NAME')
    
    # Initialize AWS clients
    s3_client = boto3.client('s3')
    ec2_client = boto3.client('ec2')
    
    try:
        # Get current timestamp
        timestamp = datetime.now().isoformat()
        
        # Create response data
        response_data = {
            'message': f'Hello from {project_name} Lambda function!',
            'timestamp': timestamp,
            'project_name': project_name,
            's3_bucket': s3_bucket,
            'event': event
        }
        
        # Write to S3 bucket
        if s3_bucket:
            log_key = f'lambda-logs/{timestamp}.json'
            s3_client.put_object(
                Bucket=s3_bucket,
                Key=log_key,
                Body=json.dumps(response_data, indent=2),
                ContentType='application/json'
            )
            response_data['s3_log_location'] = f's3://{s3_bucket}/{log_key}'
        
        # Get EC2 instances information (if any)
        try:
            ec2_response = ec2_client.describe_instances(
                Filters=[
                    {
                        'Name': 'tag:Project',
                        'Values': [project_name]
                    },
                    {
                        'Name': 'instance-state-name',
                        'Values': ['running']
                    }
                ]
            )
            
            instances = []
            for reservation in ec2_response['Reservations']:
                for instance in reservation['Instances']:
                    instances.append({
                        'instance_id': instance['InstanceId'],
                        'instance_type': instance['InstanceType'],
                        'state': instance['State']['Name'],
                        'public_ip': instance.get('PublicIpAddress', 'N/A'),
                        'private_ip': instance.get('PrivateIpAddress', 'N/A')
                    })
            
            response_data['ec2_instances'] = instances
            
        except Exception as e:
            response_data['ec2_error'] = str(e)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(response_data, indent=2)
        }
        
    except Exception as e:
        error_response = {
            'error': str(e),
            'project_name': project_name,
            'timestamp': timestamp
        }
        
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(error_response, indent=2)
        }
