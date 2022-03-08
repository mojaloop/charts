#!/usr/bin/env python3
"""
    populate helm chart values.yaml files from subchart values.yaml files
"""
import sys
import re

""" 
Todo:
    - take a dest values.yaml and multiple src values.yam as input params
    - write values to dest file 
    - ensure that the Globals section has all properties from all subcharts 
    - probably create a shell script to run this util i.e. with the input params set
    - consider putting this into the pipleine when done.

"""

##################################################                   
# main 
##################################################
def main(argv) : 

    read_data = "" 
    topdir="/vagrant/charts/mojaloop"
    subcharts = [ "chart-admin", "chart-service" ] 
    print (subcharts)


    with open(topdir + '/' + subcharts[1] + "/values.yaml") as f:
        read_data = f.read()

    ### get the globals section from subchart values.yaml 
    globals_start=re.search('global:', read_data, re.MULTILINE)
    if globals_start: 
        print(globals_start)
        print(globals_start.end())
    globals_end=re.search('^[a-z]',read_data[globals_start.end():],re.MULTILINE)
    if globals_end: 
        print(globals_end.end())

    offset=globals_start.end() + globals_end.start()
    print(f"offset : {offset}")
    print( f"{read_data[globals_start.start():offset]} " ) 

    ### now add the subchart specific sections
    for i in range(len(subcharts)) : 
        print(f"{subcharts[i]}:")
        x = read_data[offset:].split('\n')
        print("  ", end="")
        #print('\n  '.join(x) , end='\n')
        #print('  '.join(read_data ), end='\n')



if __name__ == "__main__":
    main(sys.argv[1:])
