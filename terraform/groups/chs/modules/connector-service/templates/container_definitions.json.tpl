[
  {
    "name": "remote-connector-server",
    "image": "${aws_ecr_url}:${tag}",
    "environment": [
      {
        "name": "RCS_CLIENT_SECRET",
        "value": "${rcs_client_secret}"
      },
      {
        "name": "FIDC_URL",
        "value": "${fidc_url}"
      },
      {
        "name": "SERVER_KEY",
        "value": "${server_key}"
      },
      {
        "name": "CONNECTOR_NAME",
        "value": "${connector_name}"
      },
      {
        "name": "ENVIRONMENT",
        "value": "${environment}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${cloudwatch_log_group_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${cloudwatch_log_prefix}"
      }
    }
  }
]