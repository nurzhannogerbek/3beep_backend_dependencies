#!/bin/bash
mkdir -p "python/lib/python3.8/site-packages"
pip install cassandra-driver==3.24.0 aws-psycopg2==1.2.1 --target "python/lib/python3.8/site-packages"
cp "src/aws_lambda_layers/databases.py" "python/lib/python3.8/site-packages"
cp "src/aws_lambda_layers/AmazonRootCA1.pem" "python/lib/python3.8/site-packages"
zip -r "src/aws_lambda_layers/archives/databases.zip" "python/lib/python3.8/site-packages"
rm -rf "python"