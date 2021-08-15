# Powershell Helpdesk Utilities
These are just a couple quick personal projects I made while learning PowerShell and are based on some pain-points from my helpdesk day job. 

## GetADUserPasswordInfo
A utility that allows a help desk technician to search for a user and retrieve relevant information about that user's account lock out status, password expiration, etc. 

Useful to quickly see if a login issue is due to an expired password, disabled account, or locked account. 

<img src="/passwordInfoScreenshot.png" alt="A screenshot of the results from running the script">


## GetADUserPhoneInfo
A utility that allows a help desk technician to search for a user and retrieve all of that user's phone numbers.  

Useful to quickly find contact methods when they might not be listed in the ticketing system. 

<img src="/phoneInfoScreenshot.png" alt="A screenshot of the results from running the script">

# Conclusion
I plan to add more of these as I think of them, and I also want to modularize the functions that are shared between multiple scripts to make everything more maintainable. 