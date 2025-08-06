#!/bin/bash
yum update -y
yum install -y httpd aws-cli

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple web page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${project_name} - EC2 Instance</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .header { background-color: #232f3e; color: white; padding: 20px; border-radius: 5px; }
        .content { padding: 20px; border: 1px solid #ddd; border-radius: 5px; margin-top: 20px; }
        .info { background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${project_name}</h1>
            <p>EC2 Instance - Infrastructure deployed via Backstage</p>
        </div>
        <div class="content">
            <h2>Instance Information</h2>
            <div class="info">
                <strong>Project:</strong> ${project_name}<br>
                <strong>S3 Bucket:</strong> ${s3_bucket}<br>
                <strong>Instance ID:</strong> <span id="instance-id">Loading...</span><br>
                <strong>Availability Zone:</strong> <span id="az">Loading...</span><br>
                <strong>Instance Type:</strong> <span id="instance-type">Loading...</span>
            </div>
            <h2>Services Status</h2>
            <div class="info">
                <p>✅ Apache HTTP Server: Running</p>
                <p>✅ AWS CLI: Installed</p>
                <p>✅ S3 Access: Configured</p>
            </div>
        </div>
    </div>
    
    <script>
        // Get instance metadata
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(response => response.text())
            .then(data => document.getElementById('instance-id').textContent = data);
            
        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(response => response.text())
            .then(data => document.getElementById('az').textContent = data);
            
        fetch('http://169.254.169.254/latest/meta-data/instance-type')
            .then(response => response.text())
            .then(data => document.getElementById('instance-type').textContent = data);
    </script>
</body>
</html>
EOF

# Create a test file and upload to S3
echo "Hello from ${project_name} EC2 instance!" > /tmp/test-file.txt
aws s3 cp /tmp/test-file.txt s3://${s3_bucket}/ec2-test-file.txt

# Log the deployment
echo "$(date): ${project_name} EC2 instance deployed successfully" >> /var/log/deployment.log
