#!/bin/bash
mkdir -p "python/lib/python3.8/site-packages"
pip install requests==2.24.0 --target "python/lib/python3.8/site-packages"
zip -r "src/aws_lambda_layers/archives/requests.zip" "python/lib/python3.8/site-packages"
rm -rf "python"