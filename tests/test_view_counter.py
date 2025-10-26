import os
import sys
from moto import mock_aws
import boto3

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "../infra/modules/view-counter/lambda"))

from view_counter_function import lambda_handler


@mock_aws
def test_increment_view_count():
    os.environ["TABLE_NAME"] = "test-portfolio-counter"
    
    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table = dynamodb.create_table(
        TableName="test-portfolio-counter",
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
        BillingMode="PAY_PER_REQUEST",
    )

    table.put_item(Item={"id": "0", "views": 0})
    assert lambda_handler({}, None) == 1
    assert table.get_item(Key={"id": "0"})["Item"]["views"] == 1
