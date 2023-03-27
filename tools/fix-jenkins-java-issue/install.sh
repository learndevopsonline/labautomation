chatgpt_print "\nThis issue comes due to installing two versions of Java in the system. \n\nNow the question is how did two versions of Java installed in your System? \n Yes, Java one version Java 11 you have installed for Jenkins agent to work, Also for CI purpose you also installed Maven, that in turn installs Java 8 as well. That is how this problem arises.\n\n To fix this we need to run this commands. \n\n Now as part of automation script run these series of commands and fix it \n\nls -l \$(ls -l \$(type java | awk '{print \$NF}') | awk '{print \$NF}')\n"
ls -l $(ls -l $(type java | awk '{print $NF}') | awk '{print $NF}')

chatgpt_print "\n\n The above command will provide us the location of which java our system is pointing to"




