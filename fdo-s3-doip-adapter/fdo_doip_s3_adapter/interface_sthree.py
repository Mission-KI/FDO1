import boto3
import botocore
import logging

from botocore.exceptions import ClientError

class S3DOIPInterface:
    s3_res = None
    bucket = None
    endpoint = None
    bucket_name = None
    secretkey = None

    def __init__(self,endpoint, bucket_name, secretkey):
        self.s3_res = boto3.resource('s3', endpoint_url=endpoint)
        self.bucket = self.s3_res.Bucket(bucket_name)
        self.bucket_name = bucket_name
        self.endpoint = endpoint
        self.secretkey = secretkey
        #if not self.bucket.creation_date:
        #    raise Exception('Bucket dont exists')

    def _self_service(self):
        return vars(self)
        
    def create(self, key, accesskey, metadata, body):
        client=boto3.client(
            's3',
            endpoint_url=self.endpoint,
            aws_access_key_id=accesskey,
            aws_secret_access_key=self.secretkey,
            )
        try:
            try:
                response = client.put_object(
                    Bucket=self.bucket_name,
                    Metadata=metadata,
                    Body=body,
                    Key=key
                    )
                return response
            except:
                print('trap')
        except ClientError as exception:
            if exception.response['Error']['Code'] == 'NoSuchKey':
                return 'NoSuchKey'
            return 'NoAuthKey'
        
    def update(self, key, accesskey, metadata, body):
        client=boto3.client(
            's3',
            endpoint_url=self.endpoint,
            aws_access_key_id=accesskey,
            aws_secret_access_key=self.secretkey,
            )
        try:
            response = client.put_object(
                Bucket=self.bucket_name,
                Metadata=metadata,
                Body=body,
                Key=key
                )
            return response
        except ClientError as exception:
            if exception.response['Error']['Code'] == 'NoSuchKey':
                return 'NoSuchKey'
            return 'NoAuthKey'
        
    def delete(self, key, accesskey):
        client=boto3.client(
            's3',
            endpoint_url=self.endpoint,
            aws_access_key_id=accesskey,
            aws_secret_access_key=self.secretkey,
            )
        try:
            response = client.delete_object(
                Key=key,
                Bucket=self.bucket_name
                )
            return response
        except ClientError as exception:
            if exception.response['Error']['Code'] == 'NoSuchKey':
                return 'NoSuchKey'
            return 'NoAuthKey'

    def retrieve(self, key, accesskey):
        client=boto3.client(
            's3',
            endpoint_url=self.endpoint,
            aws_access_key_id=accesskey,
            aws_secret_access_key=self.secretkey,
            )
        try:
            response = client.get_object(
                Key=key, 
                Bucket=self.bucket_name
                )
            return response
        except ClientError as exception:
            if exception.response['Error']['Code'] == 'NoSuchKey':
                return 'NoSuchKey'
            return 'NoAuthKey'
        
    
    
    def search(self,query,accesskey):
        client=boto3.client(
            's3',
            endpoint_url=self.endpoint,
            aws_access_key_id=accesskey,
            aws_secret_access_key=self.secretkey,
            )
        query.update({'Bucket':self.bucket_name})
        try:
            return client.list_objects_v2(**query) 
        except:
            return None
    
    def list(self):
        return [obj for obj in self.bucket.objects.all()]

if  __name__ == '__main__':
    pass