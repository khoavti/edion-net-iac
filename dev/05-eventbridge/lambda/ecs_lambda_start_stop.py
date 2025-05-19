import boto3
import logging

log = logging.getLogger()
log.setLevel(logging.INFO)

client = boto3.client('ecs')

def lambda_handler(event, context):
    cluster_list = event.get("cluster", [])
    desired_count_1 = int(event.get('desired_count_1', 0))
    desired_count_2 = int(event.get('desired_count_2', 0))
    desired_count_off = int(event.get('desired_count_off', 0))
    filter_string = event.get('filter_string', '')  # chuỗi để check tên service
    
    for cl in cluster_list:
        svclst = []

        paginator = client.get_paginator('list_services')
        iterator = paginator.paginate(
            cluster=cl,
            launchType='FARGATE',
            schedulingStrategy='REPLICA'
        )

        for page in iterator:
            svclst.extend(page.get('serviceArns', []))

        for service_arn in svclst:
            service_name = service_arn.split('/')[-1]

            if desired_count_off > 0:
                desired_count = desired_count_off
            else:
                if filter_string and filter_string in service_name:
                    desired_count = desired_count_2
                else:
                    desired_count = desired_count_1

            try:
                client.update_service(
                    cluster=cl,
                    service=service_name,
                    desiredCount=desired_count
                )
                log.info(f"Updated {service_name} in {cl} to {desired_count}")
            except Exception as e:
                log.error(f"Error updating {service_name} in {cl}: {e}")
