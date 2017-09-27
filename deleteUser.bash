#!/bin/bash
userToBeDeleted=""
echo "Evaluating groups for $userToBeDeleted"
groupsToEdit=$(groups $userToBeDeleted)
for eachGroup in $groupsToEdit
  do
    echo "Removing $userToBeDeleted from $eachGroup.."
    dseditgroup -o edit -d $userToBeDeleted -t user $eachGroup
  done
echo "Deleting $userToBeDeleted..."
dscl . delete /Local/Default/Users/$userToBeDeleted
rm -rf /Users/$userToBeDeleted
echo "Done."
