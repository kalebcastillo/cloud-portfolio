import json
import boto3
import os

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)
    
    try:
        response = table.get_item(Key={'id': '0'})
        views = response.get('Item', {}).get('views', 0)
    except Exception as e:
        print(f"Error getting item: {str(e)}")
        views = 0
    
    views = views + 1
    
    try:
        table.put_item(Item={
            'id': '0',
            'views': views
        })
    except Exception as e:
        print(f"Error putting item: {str(e)}")
        return {"error": str(e)}
    
    return views
