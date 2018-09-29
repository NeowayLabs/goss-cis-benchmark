#!/bin/bash

set -o errexit
set -o nounset

status="0"
test_fail="0"

for f in $(find -name "test_*.yml"); do
    status="0"
    echo ""
    echo "Running: goss --gossfile ${f} render"
    echo ""
    goss --gossfile ${f} render || status="1"
        if test ${status} = "0"; then
        echo ""
        echo "Test pass"
        echo "---"
    else
        echo ""
        echo "Test fail"
        test_fail="true"
        echo "---"
    fi
done

if test ${test_fail} = "true"; then
    echo ""
    echo "One or more tests failed! Check the output above."
    exit 1
else
    echo ""
    echo "All tests passed"
    exit 0
fi
