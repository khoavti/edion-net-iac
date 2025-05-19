import boto3
import json
import os

def lambda_handler(event, context):
    cluster = event.get("cluster")
    service = event.get("service")
    desired_count = event.get("desired_count")

    if not cluster or not service or desired_count is None:
        return {
            "statusCode": 400,
            "body": json.dumps("Missing required parameters")
        }

    client = boto3.client("ssm")

    try:
        response = client.start_automation_execution(
            DocumentName="AWS-UpdateECSServiceDesiredCount",
            Parameters={
                "ClusterName": [cluster],
                "ServiceName": [service],
                "DesiredCount": [str(desired_count)]
            }
        )
        return {
            "statusCode": 200,
            "body": json.dumps(f"Started AutomationExecution: {response['AutomationExecutionId']}")
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps(str(e))
        }
