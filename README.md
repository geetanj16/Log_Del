I needed to write a code that deletes the constantly forming files inside a folder skipping the 3 latest files according to creation date, last accessed date and late updated date combined as if the file is in the process the updated time wille constatntly be updated and the code wouldn't know which file to delete.
The problem i faced was that whenever these files were in process my code was not able to terminate it.

To counter this challenge i used Handle which is a utility that displays information about open handles for any process in the system by sysinternals, Microsoft.
Using this i was able to identify the pid and code to terminate the process first and then delete the file.
