FROM python:3.9-slim-buster

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
ENV TERRAFORM_VERSION=1.0.11
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install CDK for Terraform CLI
ENV CDKTF_VERSION=0.8.2
RUN curl -LO "https://github.com/hashicorp/terraform-cdk/releases/download/v${CDKTF_VERSION}/cdktf-cli_${CDKTF_VERSION}_linux_amd64.tar.gz" && \
    tar -xzf cdktf-cli_${CDKTF_VERSION}_linux_amd64.tar.gz && \
    mv cdktf /usr/local/bin && \
    rm cdktf-cli_${CDKTF_VERSION}_linux_amd64.tar.gz

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