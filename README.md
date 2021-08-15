# Powershell Helpdesk Utilities
A collection of custom PowerShell utilities and functions to assist with helpdesk tasks


## GetADUserPasswordInfo
A utility that allows a help desk technician to search for a user and retrieve relevant information about that user's account lock out status, password expiration, etc. 

Useful to quickly see if a login issue is due to an expired password, disabled account, or locked account. 

<img src="/passwordInfoScreenshot.png" alt="A screenshot of the results from running the script">


## GetADUserPhoneInfo
A utility that allows a help desk technician to search for a user and retrieve all of that user's phone numbers.  

Useful to quickly find contact methods when they might not be listed in the ticketing system. 

<img src="/phoneInfoScreenshot.png" alt="A screenshot of the results from running the script">


# Conclusion
These are just a couple quick utilities I made while learning PowerShell based on some pain-points from my help desk day job. I plan to add more of these and also modularize many of the functions that are shared between multiple scripts. 