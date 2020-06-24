#!/bin/bash

echo "Jenkins Fake Bad Build task"

RANDOM_FAIL=$(($RANDOM%10))
RANDOM_LONG=$(($RANDOM%10))

echo "Random Fail number is: $RANDOM_FAIL"

if (( $RANDOM_FAIL > 6  )); then
  echo 'Fake Fail !!'
  exit 1
fi

echo "Random Long task number is: $RANDOM_LONG"

if (( $RANDOM_LONG > 6 )); then
  echo 'We will sleep for a bit long'
  sleep $(( ${RANDOM_LONG} + 15 ))
else
  echo 'This time the task is short'
  sleep ${RANDOM_LONG}
fi

exit 0