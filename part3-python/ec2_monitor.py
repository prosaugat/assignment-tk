#!/usr/bin/env python3

import argparse
import json
import logging
import statistics
from datetime import datetime, timedelta
from typing import Dict, List, Any
import boto3
from botocore.exceptions import ClientError
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)

logger = logging.getLogger(__name__)


def load_config(path: str) -> Dict[str, Any]:
    try:
        with open(path, "r") as file:
            return json.load(file)
    except Exception as exc:
        logger.error("Unable to read config: %s", exc)
        return {}


def get_cpu_metrics(cloudwatch, instance_id: str) -> Dict[str, float]:
    end = datetime.utcnow()
    start = end - timedelta(hours=1)

    try:
        response = cloudwatch.get_metric_statistics(
            Namespace="AWS/EC2",
            MetricName="CPUUtilization",
            Dimensions=[
                {
                    "Name": "InstanceId",
                    "Value": instance_id
                }
            ],
            StartTime=start,
            EndTime=end,
            Period=300,
            Statistics=["Average", "Minimum", "Maximum"]
        )

        values = [
            point["Average"]
            for point in response.get("Datapoints", [])
        ]

        if not values:
            return {
                "average": 0,
                "minimum": 0,
                "maximum": 0
            }

        return {
            "average": round(statistics.mean(values), 2),
            "minimum": round(min(values), 2),
            "maximum": round(max(values), 2)
        }

    except ClientError as exc:
        logger.error(
            "CloudWatch error for %s: %s",
            instance_id,
            exc
        )

        return {
            "average": 0,
            "minimum": 0,
            "maximum": 0
        }


def collect_instances(region: str, threshold: float) -> List[Dict[str, Any]]:

    ec2 = boto3.client(
        "ec2",
        region_name=region
    )

    cloudwatch = boto3.client(
        "cloudwatch",
        region_name=region
    )

    report = []

    try:
        response = ec2.describe_instances(
            Filters=[
                {
                    "Name": "instance-state-name",
                    "Values": ["running"]
                }
            ]
        )

        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:

                name = "unknown"

                for tag in instance.get("Tags", []):
                    if tag["Key"] == "Name":
                        name = tag["Value"]

                metrics = get_cpu_metrics(
                    cloudwatch,
                    instance["InstanceId"]
                )

                report.append({
                    "instance_id": instance["InstanceId"],
                    "name": name,
                    "type": instance["InstanceType"],
                    "cpu": metrics,
                    "high_usage":
                        metrics["average"] > threshold
                })

    except ClientError as exc:
        logger.error(
            "AWS API error: %s",
            exc
        )

    return report


def main():

    parser = argparse.ArgumentParser(
        description="EC2 CPU monitoring report"
    )

    parser.add_argument(
        "--region",
        default="us-east-1"
    )

    parser.add_argument(
        "--threshold",
        type=float,
        default=80
    )

    parser.add_argument(
        "--output",
        default="report.json"
    )

    parser.add_argument(
        "--config",
        default="config.json"
    )

    args = parser.parse_args()

    load_config(args.config)

    report = collect_instances(
        args.region,
        args.threshold
    )

    with open(args.output, "w") as file:
        json.dump(
            report,
            file,
            indent=4
        )

    logger.info(
        "Report generated: %s",
        args.output
    )

if __name__ == "__main__":
    main()

