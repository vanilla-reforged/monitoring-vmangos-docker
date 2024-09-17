#!/bin/bash
echo "heartbeat{job=\"manual\"} 1" | curl --data-binary @- http://localhost:9091/metrics/job/heartbeat
