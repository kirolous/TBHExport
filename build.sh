#!/bin/bash
#######################################################################
# 
# This script generates scripts to migrate entire toonboom harmony environments  -The Hero;)
#
#######################################################################

# Variables to edit 
exportBasePath="/"  #Change this to the path you want the exports to be saved to 
TBFilesysName="/USADATA" #The name of the Harmony file system on the iporting server 
importBasePath="" # Change this to the path you want the imports tto be saved to 
####################################

		if [[ ! "$PWD" =~ TBHExport ]]; then
					echo "Please Run this script from TBHExport! Exiting "
                    exit
						
        fi
		if [  -d ./Environments ]; then
                       rm -rf ./Environments 
						
        fi
		if [ ! -d ./Environments ]; then
                        mkdir ./Environments
                        #echo "Creating Directory !"
        fi


filename="./joblist.txt"
		
dbu -sh "Name"" Env" /USA_DB/online_jobs/jobs.db > $filename # Dump all jobs 

# Create enviroment files and separte all jobs in to their respective environments 
while read -r line
do

        if [[ $line = *"Name:"* ]]; then
                job="${line:5}"
                #echo $job
        fi

	envs="Env:"
	if [[ $line = *"Env:"* ]]; then
                env="${line:4}"
                #echo $env


		if [ ! -f ./Environments/$env ]; then
			touch ./Environments/$env
    			#echo "Creating file !"
		fi
		echo $job >> ./Environments/$env
  	fi

done < "$filename"
#####################################################

#Get User input 
Listenvs="$(ls -l ./Environments | awk {'print test $9'})"
envArray=($Listenvs)
echo "****************************************************************************************************************"
echo "Environment List : "
echo "****************************************************************************************************************"
for each in "${envArray[@]}"
do
  echo "$each"
done
echo "****************************************************************************************************************"
echo "Please Type the name of the Environment you would like to export "
echo "****************************************************************************************************************"

flag=0

while true ; do
	read uinput 
	if [ -z "$uinput" ]
then
echo "No input recived ! "
fi
	for each in "${envArray[@]}"
		do
			if [[ "$each" = "$uinput" ]]; then
				flag=1
			fi
		done
	
	if [ $flag -eq 1 ]
	then
	
	break
	fi
	echo "Did not find env: $uinput, try again "

done
##########################################

# Generate commands for the exports 
envFile="./Environments/$uinput"
exportScriptPath="./ExportScripts/$uinput"".sh"
		if [ ! -d ./ExportScripts ]; then
                        mkdir ./ExportScripts
                        echo "Creating export scripts directory  !"
        fi
echo "#!/bin/bash" > $exportScriptPath
echo "" >> $exportScriptPath
chmod +x $exportScriptPath

while read -r line
	do
		exportPath="$exportBasePath/$uinput/$line/"
		echo "Controlcenter -batch -export -export_env $uinput -export_job $line -path $exportPath" >>  $exportScriptPath
	done < "$envFile"
#######################################


# Generate commands for the imports 
envFile="./Environments/$uinput"
importScriptPath="./ImportScripts/$uinput"".sh"
		if [ ! -d ./ImportScripts ]; then
                        mkdir ./ImportScripts
                        echo "Creating import scripts directory  !"
        fi
echo "#!/bin/bash" > $importScriptPath
echo "" >> $importScriptPath
chmod +x $importScriptPath

while read -r line
	do
		importPath="$importBasePath/$uinput/$line/IEContents.dat"
		echo "Controlcenter -batch -import -import_env $uinput -import_job $line -path $importPath" >>  $importScriptPath
		echo "Controlcenter -batch -import -target_env $uinput -target_job  $line -filesys $TBFilesysName -path $importPath" >>  $importScriptPath
	done < "$envFile"
#######################################

echo "You should now have ExportScript and ImportScripts folders , Run the ExportsScripts on the EXPORTING server and the ImportScripts on the IMPORTING server  "
