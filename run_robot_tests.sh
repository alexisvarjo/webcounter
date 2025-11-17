#!/bin/bash
set -e

echo "Running tests"

start_flask() {
    echo "Starting Flask server..."
    poetry run python3 src/index.py &
    FLASK_PID=$!

    # wait until server returns HTTP 200 OK
    until curl -s -o /dev/null -w ''%{http_code}'' http://localhost:5001 | grep -q "200"
    do
        sleep 1
    done

    echo "Flask server ready (PID $FLASK_PID)"
}

stop_flask() {
    echo "Stopping Flask server (PID $FLASK_PID)..."
    kill $FLASK_PID || true
    sleep 1
}

# --- Run each suite separately and restart Flask between each run ---

overall_status=0

for suite in src/tests/*.robot; do
    # skip resource.robot
    if [[ "$(basename "$suite")" == "resource.robot" ]]; then
        continue
    fi
    echo ""
    echo "==============================="
    echo " Running suite: $suite"
    echo "==============================="

    start_flask

    # Run the suite
    poetry run robot --variable HEADLESS:true "$suite"
    suite_status=$?

    stop_flask

    # accumulate error status
    if [ $suite_status -ne 0 ]; then
        overall_status=$suite_status
    fi
done

exit $overall_status
