provider "aws" {
  region = "us-east-2"
}
 
module "s3_web" {
  source      = "./modules/s3_web"
  bucket_name = "texttospeech-proj-azubi-Nana"
  }
  module "cloudfront" {
  source              = "./modules/cloudfront"
  bucket_domain_name  = module.s3_web.static_site_endpoint
  bucket_id           = module.s3_web.static_site_bucket_name
  bucket_arn          = module.s3_web.static_site_bucket_arn
  price_class         = "PriceClass_100"
  default_root_object = "index.html"

}
 

