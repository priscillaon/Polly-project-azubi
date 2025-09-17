# AWS Text-to-Speech Website (Terraform + Polly + API Gateway)

This project provisions a **serverless text-to-speech (TTS) web application** using **Terraform** and AWS services.  
Users can input text in a web page, which is sent to an **API Gateway → Lambda → Amazon Polly** pipeline.  
Polly generates speech audio (MP3), stores it in S3, and the response is sent back for immediate playback.

---

## 🚀 Architecture Overview

- **Amazon S3**  
  - Hosts the static frontend (HTML, CSS, JS).  
  - Stores generated Polly audio files.  

- **Amazon CloudFront**  
  - Distributes the static site globally.  
  - Provides fast, secure HTTPS access to the frontend.  

- **AWS Lambda**  
  - Runs Python code to call Amazon Polly.  
  - Encodes audio, saves to S3, and returns Base64 audio to the frontend.  

- **Amazon Polly**   
  - Supports multiple voices, pitch, and rate.  
  - Converts user input text into speech.

- **Amazon API Gateway**  
  - Exposes a `/tts` POST endpoint.  
  - Connects frontend with the Lambda function.  

---

## 📂 Project Structure

```

project-root/
├── main.tf
├── variables.tf
├── output.tf
├── modules/
│   ├── s3_web/         # S3 bucket + website config
│   ├── s3_audio/       # S3 bucket + audio config
│   ├── cloudfront/     # CloudFront distribution
│   ├── lambda/         # Lambda + Python code for Polly
│   └── api_gateway/    # API Gateway REST API + routes
└── static-site/        # HTML, CSS, JS frontend files

````

---
## Architecture Diagram 
![Architecture Diagram](./polly_architecturediagram/Text_to_speechproj.drawio.png) 

## 🔧 Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/Stennis1/tts-aws-cloud-project.git
cd tts-aws-cloud-project
````

### 2. Configure AWS credentials

Ensure your AWS credentials are set locally:

```bash
aws configure
```

Terraform will use these credentials.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan and View Infrastructure

```bash
terraform plan
```

Terraform would show a detailed number, names and descriptions of infrastructure it would provision.

### 5. Deploy Lambda function code

Package the Lambda code:

```bash
cd modules/lambda
zip lambda_function.zip polly_lambda.py
cd ../..
terraform apply
```

Terraform will update Lambda with the zip.
Confirm with `yes` when prompted.
This will create all resources (S3, CloudFront, Lambda, API Gateway).

---

## 🌐 Access the Application

1. Open the **CloudFront domain URL** → website loads.
2. Enter text and click **Play** → API Gateway forwards it to Lambda.
3. Lambda calls **Polly**, stores audio in S3, and returns Base64.
4. Browser decodes audio and plays instantly.

---

## 📌 Future Improvements

- Add authentication for API Gateway (Cognito, API keys).
- Serve API via CloudFront under the same domain as the website.
- Support file download of MP3 audio.
- Add frontend options for pitch/rate/voice selection.

---

## ⚠️ Costs & Cleanup

This project uses AWS services that may incur costs:

- Polly requests, API Gateway, Lambda, CloudFront, and S3 storage.

To delete all resources:

```bash
terraform destroy
```

---

## 🛠 Tools & Versions

- **Terraform** ≥ 1.6
- **AWS CLI** ≥ 2.x
- **Python** 3.11 runtime for Lambda