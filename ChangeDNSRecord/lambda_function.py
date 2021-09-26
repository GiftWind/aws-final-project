import json
import boto3

ec2 = boto3.client('ec2')
route53 = boto3.client('route53')
zones = route53.list_hosted_zones_by_name(DNSName="example.com")

zone_id = zones['HostedZones'][0]['Id'].split('/')[2]

def changeDnsRecord(action, instance_id, ip_address):
       route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            'Changes': [
                {
                    'Action': action,
                    'ResourceRecordSet': {
                        'Name': f'{instance_id}.example.com',
                        'Type': 'A',
                        'TTL': 300,
                        'ResourceRecords': [{'Value': ip_address}]
                    }
                }
            ]
        }
    )

def addDnsRecord(instance_id):
    ec2_response = ec2.describe_instances(InstanceIds=[instance_id])
    ip_address = ec2_response['Reservations'][0]['Instances'][0]['PrivateIpAddress']
    changeDnsRecord('UPSERT', instance_id, ip_address)

def deleteDnsRecord(instance_id):
    ip_address = route53.list_resource_record_sets(
        HostedZoneId=zone_id,
        StartRecordName=f'{instance_id}.example.com',
        StartRecordType='A',
        MaxItems='1'
    )['ResourceRecordSets'][0]['ResourceRecords'][0]['Value']
    changeDnsRecord('DELETE', instance_id, ip_address)

def lambda_handler(event, context):
    #Parse event
    state = event["detail"]["state"]
    instance_id = event["detail"]["instance-id"]
    
    if state == "running":
        addDnsRecord(instance_id)
    elif state == "shutting-down":
        deleteDnsRecord(instance_id)
    else:
        return
        
    return {
        'statusCode': 200,
        'body': json.dumps()
    }