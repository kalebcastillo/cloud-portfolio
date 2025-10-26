import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('portfolio-counter')

def lambda_handler(event, context):
    try:
        response = table.get_item(Key={'id': '0'})
        views = response.get('Item', {}).get('views', 0)
    except:
        views = 0
    
    views = views + 1
    
    table.put_item(Item={
        'id': '0',
        'views': views
    })
    
    return views
