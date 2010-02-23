Todd
====

Powerful todo-list action at your fingertips.

Contribution
============

Right now Todd is still in its growth stages, so if you are interested
in contributing be aware that any part of the Todd api could change at any
moment.

Commands
--------

    $ todd init

Initialize a todd todo list in the local directory.

-------------------------------------------------------

    $ todd add-remote   <not implemented>

Add a connection to a remote todo list.

-------------------------------------------------------

    $ todd sync         <not implemented>

Sync to a remote todo list.

-------------------------------------------------------

    $ todd add <string>
  
Add an item to the local todo list.  <string> in format:

> "Task description #category-optional"

-------------------------------------------------------

    $ todd rm <id>

Remove an item from the local todo list.  <id> in format:

EITHER #relative-id OR <hash>.  The relative id is a short id
which comes up when you use `todd list`, and the <hash> is
enough of the task's hash to make it unique.

-------------------------------------------------------

    $ todd list

List all items (or items from a particular category).  Format
something like:

    $ todd list
    #1 task text task text task text <9e107d9d372bb6826bd81d3542a419d6>
    #2 lorem ipsum lorem ipsum <dbb804f87fdc6914a7978aae54f5958b>

    Category:
      #3 a quick brown fox did something <174a904669b71d64ef22c8b22aa80c61>
    $

-------------------------------------------------------

    $ todd find <query>

Search all tasks with a certain query.  Query format is yet to be decided.
Output format similar to list.

-------------------------------------------------------

    $ todd start <id>

Start the timer on task with id == <id>.  <id> in same format as `todd rm`

-------------------------------------------------------

    $ todd stop <id>

Stop the timer on task with id == <id>.  <id> in same format as `todd rm`
Outputs session time (time since it started) and total time.

