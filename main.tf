provider "aws" {
  region = var.aws_region
}

module "s3_web" {
  source       = "./modules/s3_web"
  bucket_name  = "polly-project-azubi-priscillaon"
  api_base_url = "module.api_gateway.invoke_url"
}

module "cloudfront" {
  source                  = "./modules/cloudfront"
  bucket_rest_domain_name = module.s3_web.static_site_bucket_regional_domain_name
  bucket_domain_name      = module.s3_web.static_site_endpoint
  bucket_id               = module.s3_web.static_site_bucket_name
  bucket_arn              = module.s3_web.static_site_bucket_arn
  price_class             = "PriceClass_100"
  default_root_object     = "index.html"
  acm_certificate_arn     = null
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = "tts-polly-lambda"
  source_path          = "${path.module}/lambda-polly.zip"
  s3_audio_bucket      = module.s3_audio.audio_bucket_name
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  api_name             = "tts-api"
  lambda_function_name = module.lambda.lambda_function_name
  lambda_invoke_arn    = module.lambda.lambda_function_arn
  aws_region           = var.aws_region
}
module "s3_audio" {
  source      = "./modules/s3_audio"
  bucket_name = "tts-audio-bucket-009-azubi-africa"
  environment = "dev"
}


 

