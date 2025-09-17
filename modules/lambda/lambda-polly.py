import boto3
import json
import base64
import os
from datetime import datetime

# Initialize clients
polly_client = boto3.client("polly")
s3_client = boto3.client("s3")

# Env var set in Terraform
AUDIO_BUCKET = os.environ.get("AUDIO_BUCKET", "your-audio-bucket-name")

def lambda_handler(event, context):
    try:
        # Parse request body
        body = json.loads(event.get("body", "{}"))
        text = body.get("text", "Hello from AWS Polly!")
        voice = body.get("voice", "Joanna")
        rate = str(body.get("rate", "1.0"))
        pitch = str(body.get("pitch", "0"))

        # --- Normalize rate (convert float -> percentage) ---
        try:
            if rate.replace(".", "", 1).isdigit():
                rate = f"{float(rate) * 100:.0f}%"
        except:
            rate = "100%"

        # --- Normalize pitch (ensure it has %) ---
        if not pitch.endswith("%") and not pitch.startswith(("+", "-")):
            pitch = f"{pitch}%"

        # Wrap with SSML for pitch/rate
        ssml_text = f"<speak><prosody rate='{rate}' pitch='{pitch}'>{text}</prosody></speak>"

        # Call Polly
        response = polly_client.synthesize_speech(
            TextType="ssml",
            Text=ssml_text,
            VoiceId=voice,
            OutputFormat="mp3"
        )

        audio_stream = response.get("AudioStream").read()

        # Save to S3 with timestamped filename
        file_key = f"tts-audio/{datetime.utcnow().isoformat()}.mp3"
        s3_client.put_object(
            Bucket=AUDIO_BUCKET,
            Key=file_key,
            Body=audio_stream,
            ContentType="audio/mpeg"
        )

        # Generate a presigned URL valid for 1 hour
        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": AUDIO_BUCKET, "Key": file_key},
            ExpiresIn=3600  # 1 hour
        )

        # Base64 for inline playback (optional)
        audio_base64 = base64.b64encode(audio_stream).decode("utf-8")
        
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*", 
                "Access-Control-Allow-Methods": "OPTIONS,POST",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": json.dumps({
                "message": "Speech generated successfully",
                "s3_key": file_key,
                "s3_presigned_url": presigned_url,
                "audio_base64": audio_base64
            })
        }

    except Exception as e:
        # print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "OPTIONS,POST",
                "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps({"error": str(e)})
        }