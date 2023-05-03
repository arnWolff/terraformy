FROM python:3.9-slim-buster

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
ENV TERRAFORM_VERSION=1.0.11
RUN curl -LO "https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip" && \
    unzip terraform_1.4.6_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_1.4.6_linux_amd64.zip

# Install CDK for Terraform CLI
ENV CDKTF_VERSION=0.16.1
RUN curl -LO "https://github.com/hashicorp/terraform-cdk/archive/refs/tags/v0.16.1.tar.gz" && \
    tar -xzf terraform-cdk-0.16.1.tar.gz && \
    mv cdktf /usr/local/bin && \
    rm terraform-cdk-0.16.1.tar.gz

# Install CDK for Terraform Python package
RUN pip install cdktf==${CDKTF_VERSION}

# Install Flask and cloud provider libraries
RUN pip install Flask google-auth google-auth-oauthlib boto3 azure-identity

# Set working directory
WORKDIR /app

# Copy app files
COPY . .

# Install app dependencies
RUN pip install -r requirements.txt

# Expose port for external access
EXPOSE 8000

# Run app
CMD ["python", "app.py"]