
import os
import boto3
import botocore
import unittest
from moto import mock_aws
from unittest import mock
from datetime import datetime
from fdo_doip_s3_adapter.WIP_test_request import *

#Testimports
from interface_sthree import S3DOIPInterface
from adapter import Doip_Server_Interface
from interface_handle import HandleInterface

TESTBUCKET = "TESTBUCKET"
TESTENDPOINT = None



@mock_aws
class TestS3Handler(unittest.TestCase):
    def setUp(self):
        client = boto3.client(
            "s3",
            region_name="us-east-1",
            aws_access_key_id="fake_access_key",
            aws_secret_access_key="fake_secret_key",
            )
        try:
            s3 = boto3.resource(
                "s3",
                region_name="us-east-1",
                aws_access_key_id="fake_access_key",
                aws_secret_access_key="fake_secret_key",
                )
            s3.meta.client.head_bucket(Bucket=TESTBUCKET)
        except botocore.exceptions.ClientError:
            pass
        else:
            err = "{bucket} should not exist.".format(bucket=TESTBUCKET)
            raise EnvironmentError(err)        
        client.create_bucket(Bucket=TESTBUCKET)
        current_dir = os.path.dirname(__file__)
        fixtures_dir = os.path.join(current_dir, "fixtures")
        _upload_fixtures(TESTBUCKET, fixtures_dir)

    def tearDown(self):
        s3 = boto3.resource(
            "s3",
            region_name="us-east-1",
            aws_access_key_id="fake_access_key",
            aws_secret_access_key="fake_secret_key",
            )
        bucket = s3.Bucket(TESTBUCKET)
        for key in bucket.objects.all():
            key.delete()
        bucket.delete()
    
    def test_create1(self):
        idoipnterface = S3DOIPInterface(TESTENDPOINT, TESTBUCKET,'fake_secret_key' )
        handleInterface = HandleInterface(prefix='prefix', url='url', certs='certs', httpPort='port')
        interface = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=idoipnterface)
        response = interface.create(TESTCREATEREQUEST1[0],TESTCREATEREQUEST1[1])
        #moto dont like datetime mocks...
        response.output.attributes['metadata']['createdon'] = '1729512539.57938'
        response.output.attributes['metadata']['modifiedon'] = '1729512539.57938'
        self.assertTrue(TESTCREATERESPONSE1==response)

    def test_create2(self):
        idoipnterface = S3DOIPInterface(TESTENDPOINT, TESTBUCKET,'fake_secret_key' )
        handleInterface = HandleInterface(prefix='prefix', url='url', certs='certs', httpPort='port')
        interface = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=idoipnterface)
        response = interface.create(TESTCREATEREQUEST2[0],TESTCREATEREQUEST2[1])
        #moto dont like datetime mocks...
        response.output.attributes['metadata']['createdon'] = '1729512539.57938'
        response.output.attributes['metadata']['modifiedon'] = '1729512539.57938'
        self.assertTrue(TESTCREATERESPONSE2==response)

    def test_retrieve(self):
        idoipnterface = S3DOIPInterface(TESTENDPOINT, TESTBUCKET,'fake_secret_key' )
        handleInterface = HandleInterface(prefix='prefix', url='url', certs='certs', httpPort='port')
        interface = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=idoipnterface)
        interface.create(TESTCREATEREQUEST1[0],TESTCREATEREQUEST1[1])
        response, data = interface.retrieve(TESTRETRIVE)
        #moto dont like datetime mocks...
        response.output.attributes['metadata']['createdon'] = '1729512539.57938'
        response.output.attributes['metadata']['modifiedon'] = '1729512539.57938'
        self.assertTrue(TESTCREATERESPONSE1==response)

    def test_retrieve2(self):
        idoipnterface = S3DOIPInterface(TESTENDPOINT, TESTBUCKET,'fake_secret_key' )
        handleInterface = HandleInterface(prefix='prefix', url='url', certs='certs', httpPort='port')
        interface = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=idoipnterface)
        interface.create(TESTCREATEREQUEST2[0],TESTCREATEREQUEST2[1])
        response, data = interface.retrieve(TESTRETRIVE2)
        #moto dont like datetime mocks...
        self.assertTrue(TESTRETRIVERESPONSEDATA==response)
        self.assertTrue(data==TESTRETRIVEDATA)

    def test_update(self):
        idoipnterface = S3DOIPInterface(TESTENDPOINT, TESTBUCKET,'fake_secret_key' )
        handleInterface = HandleInterface(prefix='prefix', url='url', certs='certs', httpPort='port')
        interface = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=idoipnterface)
        interface.create(TESTCREATEREQUEST1[0],TESTCREATEREQUEST1[1])
        response = interface.update(TESTUPDATEREQUEST1[0],TESTUPDATEREQUEST1[1])
        #moto dont like datetime mocks...
        response.output.attributes['metadata']['createdon'] = '1729512539.57938'
        response.output.attributes['metadata']['modifiedon'] = '1729512539.57938'
        self.assertTrue(TESTUPDATERESPONSE==response)
        response, data = interface.retrieve(TESTRETRIVE2)
        self.assertTrue(TESTRETRIVERESPONSEDATA==response)
        self.assertTrue(data==TESTRETRIVEDATA)

    def test_search(self):
        #!TODO Populate Bucket to test search
        idoipnterface = S3DOIPInterface(TESTENDPOINT, TESTBUCKET,'fake_secret_key' )
        handleInterface = HandleInterface(prefix='prefix', url='url', certs='certs', httpPort='port')
        interface = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=idoipnterface)
        for i in range(1,10):
            create = TESTCREATEREQUEST2[0]
            create.clientId = create.clientId + str(i)
            interface.create(create,TESTCREATEREQUEST2[1])
        response = interface.search(TESTSEARCHREQUEST)
        tmp = []
        for respons in response:
            respons.output.attributes['metadata']['createdon'] = '1729512539.57938'
            respons.output.attributes['metadata']['modifiedon'] = '1729512539.57938'
            tmp.append(respons)
        self.assertTrue(tmp == TESTSEARCHRESPONSE)
        

def _upload_fixtures(bucket: str, fixtures_dir: str) -> None:
    client = boto3.client("s3")
    fixtures_paths = [
        os.path.join(path,  filename)
        for path, _, files in os.walk(fixtures_dir)
        for filename in files
    ]
    for path in fixtures_paths:
        key = os.path.relpath(path, fixtures_dir)
        client.upload_file(Filename=path, Bucket=bucket, Key=key)

if __name__ == '__main__':
    unittest.main()