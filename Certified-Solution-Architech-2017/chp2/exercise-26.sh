#!/bin/bash
# Filename: exercise-26.sh
# Task: Enable Static Hosting on Your Bucket

# Create bucket
aws s3 mb s3://k-medics.site
# Configure bucket as a websitre
aws s3 website s3://k-medics.site --index-document index.html --error-document error.html
# Add bucket policy
aws s3api put-bucket-policy --bucket k-medics.site --policy file://website-policy.json
# Inspect website configuration
aws s3api get-bucket-website --bucket k-medics.site
# Upload website files
aws s3 sync dist/ s3://k-medics.site

# The website can be accessed on http://k-medics.site.s3-website.eu-west-2.amazonaws.com/
