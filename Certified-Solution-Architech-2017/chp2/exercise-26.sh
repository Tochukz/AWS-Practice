#!/bin/bash
# Filename: exercise-26.sh
# Task: Enable Static Hosting on Your Bucket

# Create bucket
aws s3 mb s3://nhis.k-medics.site
# Configure bucket as a website
aws s3 website s3://nhis.k-medics.site --index-document index.html --error-document error.html
# Add bucket policy
aws s3api put-bucket-policy --bucket nhis.k-medics.site --policy file://website-policy.json
# Inspect website configuration
aws s3api get-bucket-website --bucket nhis.k-medics.site
# Upload website files
aws s3 sync dist/ s3://nhis.k-medics.site

# The website can be accessed on http://nhis.k-medics.site.s3-website.eu-west-2.amazonaws.com/

### Using custom domain 
# To access the site using your own domain: 
# Add a new CNAME record with the subdomain (nhis) as the host and the bucket endpoint (nhis.k-medics.site.s3-website.eu-west-2.amazonaws.com) as the value. 
# You can then access the site at nhis.k-medics.site 