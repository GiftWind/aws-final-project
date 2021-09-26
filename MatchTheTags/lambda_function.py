import json
import boto3

ec2 = boto3.resource('ec2')
ec2_client = boto3.client('ec2')


def lambda_handler(event, context):
    ids = [instance.id for instance in ec2.instances.all()]
    for id in ids:
        instance = ec2.Instance(id)
        instance_tags = instance.tags
        volumes = ec2.Instance(id).volumes.all()
        for volume in volumes:
            ec2_client.create_tags(
                Resources = [volume.id],
                Tags = instance_tags
            )