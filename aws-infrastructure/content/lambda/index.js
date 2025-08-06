const AWS = require('aws-sdk');

// Initialize AWS clients
const s3 = new AWS.S3();
const ec2 = new AWS.EC2();

exports.handler = async (event, context) => {
    /**
     * Lambda function handler for ${{ values.name }}
     * 
     * This function demonstrates integration with S3 and provides
     * basic functionality for the infrastructure stack.
     */
    
    // Get environment variables
    const s3Bucket = process.env.S3_BUCKET;
    const projectName = process.env.PROJECT_NAME;
    
    try {
        // Get current timestamp
        const timestamp = new Date().toISOString();
        
        // Create response data
        const responseData = {
            message: `Hello from ${projectName} Lambda function!`,
            timestamp: timestamp,
            project_name: projectName,
            s3_bucket: s3Bucket,
            event: event
        };
        
        // Write to S3 bucket
        if (s3Bucket) {
            const logKey = `lambda-logs/${timestamp}.json`;
            
            await s3.putObject({
                Bucket: s3Bucket,
                Key: logKey,
                Body: JSON.stringify(responseData, null, 2),
                ContentType: 'application/json'
            }).promise();
            
            responseData.s3_log_location = `s3://${s3Bucket}/${logKey}`;
        }
        
        // Get EC2 instances information (if any)
        try {
            const ec2Response = await ec2.describeInstances({
                Filters: [
                    {
                        Name: 'tag:Project',
                        Values: [projectName]
                    },
                    {
                        Name: 'instance-state-name',
                        Values: ['running']
                    }
                ]
            }).promise();
            
            const instances = [];
            ec2Response.Reservations.forEach(reservation => {
                reservation.Instances.forEach(instance => {
                    instances.push({
                        instance_id: instance.InstanceId,
                        instance_type: instance.InstanceType,
                        state: instance.State.Name,
                        public_ip: instance.PublicIpAddress || 'N/A',
                        private_ip: instance.PrivateIpAddress || 'N/A'
                    });
                });
            });
            
            responseData.ec2_instances = instances;
            
        } catch (error) {
            responseData.ec2_error = error.message;
        }
        
        return {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify(responseData, null, 2)
        };
        
    } catch (error) {
        const errorResponse = {
            error: error.message,
            project_name: projectName,
            timestamp: new Date().toISOString()
        };
        
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify(errorResponse, null, 2)
        };
    }
};
