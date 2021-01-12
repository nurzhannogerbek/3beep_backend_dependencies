#!/bin/bash
mkdir -p "python/lib/python3.8/site-packages"
cp "src/aws_lambda_layers/utils.py" "python/lib/python3.8/site-packages"
zip -r "src/aws_lambda_layers/archives/utils.zip" "python/lib/python3.8/site-packages"
rm -rf "python"