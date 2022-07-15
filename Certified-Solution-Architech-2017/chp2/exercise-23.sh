#!/bin/bash
# Filename: exercise-23.sh
# Task: Enable version control

aws s3api put-bucket-versioning --bucket tochukwu1-bucket --versioning-configuration Status=Enabled