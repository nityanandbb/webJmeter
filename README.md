# web-tauras-performance-testing
For QA performance testing
# JMeter Testing Framework

## Overview

This framework allows you to run JMeter tests dynamically based on configuration files. It includes scripts to run tests, archive reports, and generate HTML reports.

## Directory Structure

```plaintext
jmetr/
├── .github/
│   └── workflows/
│       └── action.yml
├── jmeter/
│   ├── tests/
│   │   ├── smoke/
│   │   │   ├── smoke_test1.jmx
│   │   │   ├── smoke_test2.jmx
│   │   │   └── ...
│   │   ├── regression/
│   │   │   ├── regression_test1.jmx
│   │   │   ├── regression_test2.jmx
│   │   │   └── ...
│   │   └── performance/
│   │       ├── perf_test1.jmx
│   │       ├── perf_test2.jmx
│   │       └── ...
│   ├── functions/
│   │   ├── test_setup.jmx
│   │   ├── test_teardown.jmx
│   │   ├── common_functions.jmx
│   │   └── custom_assertions.jmx
│   └── config/
│       ├── environments/
│       │   ├── dev.properties
│       │   ├── staging.properties
│       │   └── prod.properties
│       ├── config.properties
│       ├── user.properties
│       └── test_execution.properties
├── taurus/
│   ├── configs/
│   │   ├── smoke.yml
│   │   ├── regression.yml
│   │   └── performance.yml
│   ├── global.yml
│   └── extensions/
│       └── custom_extensions.py
├── reports/
│   ├── latest/
│   │   ├── index.html
│   │   ├── jmeter/
│   │   └── taurus/
│   └── archive/
│       ├── 2024-05-31/
│       │   ├── index.html
│       │   ├── jmeter/
│       │   └── taurus/
│       └── ...
├── scripts/
│   ├── run_tests.sh
│   ├── archive_reports.sh
│   └── generate_reports.sh
├── version.txt
└── README.md

# act workflow_dispatch  // Using Act tool for local test and github workflows executions.
act -j jmeter_tests
Running the Workflow with act
After correcting the YAML, you should be able to run it with act:

act -W .github/workflows/jmeter_tests.yml
If you need to pass specific inputs, use the -e flag to specify an event JSON file:

act -W .github/workflows/jmeter_tests.yml -e event.json

 "testfilesList":"testfile1|/path/to/folder1/ testfile2|/path/to/folder2/ test2.jmx|web-performance/jmeter/tests/performance/ test1.jmx|",


${__P(threadCount,1)}  // to set threads count find <intProp name="ThreadGroup.num_threads">${__P(threadCount,1)}</intProp>
find  " ThreadGroup.num_threads "

>> add thread var count  :- ${__P(threadCount,1)}

it should look like :-  <intProp name="ThreadGroup.num_threads">${__P(threadCount,1)}</intProp>

web-performance/jmeter/tests/performance/assignment5.jmx

./scripts/threads_count_update.sh "jmeter/tests/performance/assignment3.jmx" "2322"

jmeter/tests/performance/assignment3.jmx

./scripts/threadAlt.sh "jmeter/tests/performance/assignment3.jmx" "2322"
./scripts/threads_count_update.sh "jmeter/tests/performance/tm.jmx" "2322"
