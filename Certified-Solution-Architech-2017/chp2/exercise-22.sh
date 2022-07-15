#!/bin/bash
# Filename: exercise-22.sh
# Task: Upload, Make Public, Rename, and Delete Objects in Your Bucket

### Upload to bucket
aws s3 ls # List all the buckets
aws s3 cp logo512.png s3://tochukw1-bucket

### Accessing the object
curl https://tochukwu1-bucket.s3.eu-west-2.amazonaws.com/logo512.png
# Accessing the file should return Access Denied

### Make Public
aws s3api put-object-acl --bucket tochukwu1-bucket --key logo512.png --acl public-read
# The file should now be accssible

### Rename the object
aws s3 ls tochukwu1-bucket # List all the objects in the bucket
aws s3 mv s3://tochukwu1-bucket/logo512.png s3://tochukwu1-bucket/logo.png

### Delete object
aws s3 rm s3://tochukwu1-bucket/logo.png
