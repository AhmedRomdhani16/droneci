#!/bin/bash

# Test 1: Basic ping with larger payload
echo "Test 1: Sending larger ping payload..."
curl -v -X POST \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -d '{
    "zen": "Testing webhook",
    "hook_id": 514638119,
    "repository": {
      "id": 892338014,
      "name": "droneci",
      "full_name": "AhmedRomdhani16/droneci"
    },
    "sender": {
      "login": "AhmedRomdhani16"
    }
  }' \
  https://observe-dsi-io.esprit.tn/hook

echo -e "\n\nTest 2: Sending push event payload..."
# Test 2: Push event simulation
curl -v -X POST \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: push" \
  -H "X-GitHub-Delivery: $(uuidgen)" \
  -d '{
    "ref": "refs/heads/main",
    "repository": {
      "id": 892338014,
      "name": "droneci",
      "full_name": "AhmedRomdhani16/droneci",
      "private": false,
      "owner": {
        "login": "AhmedRomdhani16"
      }
    },
    "commits": [
      {
        "id": "test-commit-id",
        "message": "Test commit",
        "timestamp": "2024-11-22T21:24:14Z"
      }
    ]
  }' \
  https://observe-dsi-io.esprit.tn/hook

# Test 3: Testing with timeout settings
echo -e "\n\nTest 3: Testing with increased timeout..."
curl -v -X POST \
  --max-time 30 \
  --connect-timeout 10 \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: push" \
  -H "X-GitHub-Delivery: $(uuidgen)" \
  -d @- https://observe-dsi-io.esprit.tn/hook << 'EOF'
{
  "ref": "refs/heads/main",
  "repository": {
    "id": 892338014,
    "name": "droneci",
    "full_name": "AhmedRomdhani16/droneci",
    "private": false,
    "owner": {
      "login": "AhmedRomdhani16"
    }
  },
  "commits": [
    {
      "id": "test-commit-id",
      "message": "Test commit",
      "timestamp": "2024-11-22T21:24:14Z",
      "added": ["file1.txt"],
      "modified": ["file2.txt"],
      "removed": []
    }
  ],
  "head_commit": {
    "id": "test-commit-id",
    "message": "Test commit",
    "timestamp": "2024-11-22T21:24:14Z"
  }
}
EOF
