#!/bin/bash
# Filename: exercise-23.sh
# Task: Delete an Object and Then Restore It

### Delete Object
aws s3 rm s3://tochukwu1-bucket/index.html

### Restore the object
# Method 1: Get the latests/topmost version and reupload it
aws s3api list-object-versions --bucket tochukwu1-bucket --prefix index.html
aws s3api get-object --bucket tochukwu1-bucket --key index.html --version-id FeisGouCRM834uYKCGW41uO_1gVOgskK index.html
aws s3 cp index.html s3://tochukw1-bucket

# Method 2: Remove the Delete Marker found in the version list
aws s3api list-object-versions --bucket tochukwu1-bucket --prefix index.html
aws s3api delete-object --bucket tochukwu1-bucket --key index.html --version-id MyvBz8MyuuHhk2KIEsxWNyvE4HMLg_4V

# Warning: Review the version ID carefully to be sure that it's the version ID of the delete marker.
# If you delete an object version, it can't be retrieved.

[Learn More](https://aws.amazon.com/premiumsupport/knowledge-center/s3-undelete-configuration/)
