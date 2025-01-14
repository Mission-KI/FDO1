# FDO-DOIP-S3-adapter

This is a DOIP-adapter for S3.

## S3 Requirements

By the time you configured your s3 storage you need the following data from your storage:

* Bucket: Name of the Bucket (String)
* Endpoint: Endpoint Url (URL)
* Access Key: Your Access Key (String)
  * User will use this to authenticate to the Adapter
* Secret Key: Your Secret Key (String)
  * This should not go public

## Configuration

At the top of the example server ```server.py``` you will find a list of Variabels you need to change in order to configure the adapter to your personal setup

|Variable|Example Value|Description|Type|
| - | - | - | - |
| PREFIX | '25.F42069' | Your prefix | string |
| HOST | '0.0.0.0' | Dont change | string |
| PORT | 9122 | - | int |
| IP | '100.101.102.103' | your adapters publicly available ip | string |
| ENDPOINT | 'https://mttw.s3.com' | The enpoint you got from your s3 stroage | string |
| BUCKETNAME | 'example_bucket' | Your bucket name | string |
| HANDLEURL | 'https://mttw.handle.com' | Url to your handle server | string |
| HANDLEPORT | '8000' | - | string |
| HANDLECERT | ('/etc/ssl/cert.pem', '/etc/ssl/cert.pem') | The path to your handle cert and key respectivly ** | tuble of strings |
| PUBLICKEY | 'your public key' | The public key of your adapter | sting |
| PROTOCOL | 'doip' | the protocol the server speaks hence it is a doip to s3 adapter the protocol should be doip | sting |
| PROTOCOLVERSION | '1' | the version of the protocol | sting |
| AWSSECRETKEY | 'your aws secret key' | - | sting |

when these configes match your setup the example adapter shoud work out of the box

** You have to generate the cert and key from your ```admpriv.bin```. You get the file after you setup your handle server. For more informations: [follow link](https://www.youtube.com/watch?v=4rfwO-76T1M)

## Authentication

Out of the box the adapter will use the ```S3 Access Key``` to authenticate to the the storage.
Hence you need to give the Access Key to everyone, you want to use the adapter.

Without change your first doip segment will need a authentiction section structured as follows:

```json
{
    authentication = {
        "token":'your access key'
        }
}
```

You can change your method of authentication at any point in time.

Within ```adapter.py``` you will find the function ```_check_authentication```. You can change the function to your specific needs.

Note the funticon should return a boolean
representation of the authentication status.

ALso note that the request still have to contain the ```"key":"access key"``` key in the authentication section.

## Usage

### Setup

* Install the required python packages
* Change the required settings in ```server.py```
* Create a service file for your adapter
* Start your service
* Troubleshoot

### Client

Connect to the adapter via:

```shell
openssl s_client -connect  141.5.107.142:9000
```

then follow the standard doip protocol specifications:

Following a search example:

```json
{   
targetId = "YOURPREFIX/service",
operationId = "0.DOIP/Op.Search",
authentication = {
        "token":'YOUR_KEY'
        },
attributes = {
      "query": "{'Prefix': 'YOUR_SEARCH_QUERY' }",
      "sortFields": "[createdon, createdby, modifiedby,'ETag']"
    }   
}
#
#
```

replace ```YOUR_SEARCH_QUERY``` with a full text name of the dos your searching for.
replace ```YOUR_KEY``` with your s3 access key.
```sortFields``` is a list of keys provided by s3 you want the results to be sortet by

## Licence

This project is licenced under LGPL 3.0 or later. [gnu.org/licenses/lgpl-3.0.en.html](https://www.gnu.org/licenses/lgpl-3.0.en.html)
