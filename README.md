# Intro
This is a simple script helps Sytems Administrators to migrate entire ToonBoom Harmony Enviroments; since that option is unavilable / not implemented in Control Center 
# Dependencies
- ToonBoom harmony database server running on a linux system 
- Control Center and dbu paths have to be added to your $PATH variable . This is ussually already done when you install the database server 
- Simple linux knowledge 
# Install
- git clone https://github.com/kirolous/TBHExport
- cd TBHExport
chmod +x build.sh
# Run 
  # Step 1 (Creating the Export / Import scripts)
- vi build.sh 
Edit exportBasePath,TBFilesysName,importBasePath variables and exit (^ESC > :wq > ^ENTER)
- ./build.sh
Enter the Environment name when promted 
  # Step 2 , Run these steps on the EXPORTING server 
- cd ExportScripts
Then run the scripts in that directory 
  # Step 3 , Run these steps on the IMPORTING server
Copy the scripts generated in the folder ImportScripts and run 

