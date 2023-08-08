
!!! important
    This page is deprecated. Please use our <a href="https://launch.mod.deterlab.net/">new platform</a> and accompanying documentation.

# Network Emulation: Developer Documentation

The program graphGen is an automatic generator for Click templates based on an edge-list format. 

The [repository](https://github.com/ISIEdgeLab/graphGen) for this project implements 'Continuous Integration' with TravisCI, so in the file travis.yml you can find the installation details and requirements, as well as contribution guidelines.

**graph_gen.py**
This is the main file that is ran to convert edge-list to NS file.
It takes one required argument - input graph file to convert. There
are many optional arguments. Use -h flag to see all the optional arguments.

**ns_gen.py**
Generates an NS file associated with the given graph file. The generated file will have "enclaves" with ct, crypto, traffic and server nodes.

**click_gen.py**
Generates a click template.

**update_click_config.py**

**update_routes.py**

## Unit Tests ##

The tests subdirectory has several unit tests that can be ran using
run_test.py.

Examples:

    run_tests.py - run default set of tests
    run_tests.py MyTestSuite - run suite 'MyTestSuite'
    run_tests.py MyTestCase.testSomething - run MyTestCase.testSomething
    run_tests.py MyTestCase - run all 'test*' test methods in MyTestCase

**syntax_check.sh**
In order to run this program, first grab_nagelfar.sh needs to clone nagelfar repository.