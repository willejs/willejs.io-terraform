[
  {
    "name": "willejsio",
    "image": "willejs/willejs.io:${image_tag}",
    "cpu": 10,
    "memory": 128,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 8080
      }
    ],
    "mountPoints": [],
    "environment": [],
    "command": []
  }
]