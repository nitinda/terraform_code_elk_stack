import os
import sys
import logging
import boto3
import urllib
import traceback

from botocore.exceptions import ClientError
from io import BytesIO, StringIO
from gzip import GzipFile
from json import loads, dumps
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
from datetime import datetime
from botocore.vendored import requests

def getObject(bucket_name, object_name):

    # Retrieve the object
    s3 = boto3.client('s3')
    try:
        response = s3.get_object(Bucket=bucket_name, Key=object_name)
    except ClientError as e:
        # AllAccessDisabled error == bucket or object not found
        logging.error(e)
        return None
    # Return an open StreamingBody object
    return response['Body']

def loadIntoES(jsonPayload):

    try:
        session = boto3.Session()
        credentials = session.get_credentials()
        region = os.environ['AWS_REGION']
        awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, 'es', session_token=credentials.token)
        
        # Connect to the Elasticsearch server
        es = Elasticsearch(
            hosts=[{'host': os.environ['ES_HOST'], 'port': 443}],
            http_auth=awsauth,
            use_ssl=True,
            verify_certs=True,
            connection_class=RequestsHttpConnection
        )
        
        # Load Payload in ES
        for record in loads(jsonPayload)['Records']:
            recordJson = dumps(record)
            logging.info(recordJson)
            indexName = 'ct-' + datetime.now().strftime("%Y-%m-%d")
            
            # create an index in elasticsearch, ignore status code 400 (index already exists)
            res = es.index(index=indexName, doc_type='record', id=record['eventID'], body=recordJson)
    except ClientError as e:
        logging.error(e)
        return None
    return res


def lambda_handler(event, context):

    # Extract s3 bucket name and key
    s3_bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    s3_bucket_key = event["Records"][0]["s3"]["object"]["key"]
    
    # Set up logging
    logging.basicConfig(level=logging.DEBUG,format='%(levelname)s: %(asctime)s: %(message)s')
    logger = logging.getLogger()

    # Retrieve the object
    stream = getObject(s3_bucket_name, s3_bucket_key)

    if stream is not None:
        # Read first chunk of the object's contents into memory as bytes
        content = GzipFile(None, 'rb', fileobj=BytesIO(stream.read())).read().decode('utf-8')

        # ES Load
        response = loadIntoES(content)

        logger.info(response)


