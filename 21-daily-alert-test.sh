#!/bin/bash
echo "heartbeat{job=\"manual\"} 1" | curl --data-binary @- http://127.0.0.1:9091/metrics/job/heartbeat
