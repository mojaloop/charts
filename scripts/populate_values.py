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
    - ensure that the Globals section has all properties from all subcharts i.e diff and merge or perhaps 
      just check the longest set of global properties from the subcharts and use these 
    - probably create a shell script to run this util i.e. with the input params set
    - consider putting this into the pipleine when done.

"""
read_data = "" 
topdir="/vagrant/charts/mojaloop"
topchart="account-lookup-service"


def get_globals_offset (data) : 
    """
            get and return the pointer to the end of the Globals section of the 
            subchart
            returns : offset if found  or -1 if not found 
    """
    ### get the globals section from subchart values.yaml 
    globals_start=re.search('global:', data, re.MULTILINE)
    if globals_start: 
        print(globals_start)
        print(globals_start.end())
    globals_end=re.search('^[a-z]',data[globals_start.end():],re.MULTILINE)
    if globals_end: 
        print(globals_end.end())

    offset=globals_start.end() + globals_end.start()
    return globals_start.start() , offset

##################################################                   
# main 
##################################################
def main(argv) : 

    subcharts = [ "chart-admin", "chart-service"]
    subchart_data_list = []
    subchart_start_offset_list = []
    subchart_end_offset_list = []

    max_globals_sec = 0 
    max_ptr=0


    for i in range(len(subcharts)) : 
        with open(topdir + '/' + subcharts[i] + "/values.yaml") as f:
            read_data = f.read()
        subchart_data_list.append(read_data)
        sos, eos = get_globals_offset(read_data)
        subchart_start_offset_list.append(sos)
        subchart_end_offset_list.append(eos)
        if (eos - sos > max_globals_sec ) :
            max_ptr = i
            max_globals_sec=eos-sos 
    
    # write the globals section to the toplevel chart from the subchart with the 
    # longest globals section. 
    with open(topdir+'/'+topchart+'/values.yaml','w') as f:
        s = subchart_data_list[max_ptr]
        globals_section=s[subchart_start_offset_list[max_ptr]:subchart_end_offset_list[max_ptr] ]
        print (globals_section, file=f)
        print("## configurable values for subcharts ", file=f)

        ### now add the subchart specific sections
        for i in range(len(subcharts)) : 
            sc_data = subchart_data_list[i]
            sc_offset =  subchart_end_offset_list[i]
            print(f"{subcharts[i]}:",file=f)
            x = sc_data[sc_offset:].split('\n')
            print('  ', end='', file=f)
            print('\n  '.join(x) , end='\n',file=f)
    

        



if __name__ == "__main__":
    main(sys.argv[1:])
