#!/usr/bin/python3.6
import boto3
import logging
from botocore.exceptions import ClientError
from botocore.client import Config

config = Config(
    parameter_validation=False,
    retries = {
        'max_attempts': 1
    }
)

# https://stackoverflow.com/questions/58828800/adding-custom-headers-to-all-boto3-requests
def _add_header(request, **kwargs):
    request.headers.add_header('x-weka-access-secret', 'weka_secret')
    print(request.method, request.url, 'HTTP/1.1')  # for debug
    print(request.headers)  # for debug

s3_client = boto3.client('s3', 
        endpoint_url='https://192.168.0.181:9000',
        aws_access_key_id='jomoon', # 's3_key',
        aws_secret_access_key='Changeme12!@', # 's3_secret',
        config=config,
        region_name='ignored-by-minio', verify=False)

event_system = s3_client.meta.events
event_system.register_first('before-sign.*', _add_header)

try:
    response = s3_client.list_buckets()
		
    print('Existing buckets:')
    for bucket in response['Buckets']:
        print(f'  {bucket["Name"]}')

except ClientError as e:
    logging.error(e)

