This is a coding challenge submitted to Fetch Rewards.

To use this web service, you will need to install the following if you do not have them already:

**Ruby**:<br />
-If you are using Windows, go to https://rubyinstaller.org/downloads/ and select => Ruby+Devkit 2.7.3-1 (x64)<br />
-If you are using Linux, run the command `sudo apt install ruby-full`<br />
-Ruby should be installed already if you are using Mac OS

**Rails**:<br />
-If you are using Windows or Mac OS, run the command `gem install rails`<br />
-If you are using Linux, run the command `install rails`

**Node**: Go to https://nodejs.org/en/download/ and download the appropriate installer

**Yarn**: After installing Node, run the command `npm install --global yarn`

**(Optional, useful for testing routes) Postman**: https://www.postman.com/downloads/

<br />

To get a copy of this repository, run the following:
`git clone https://github.com/mmoroney01/fetch-rewards-coding-exercise.git`

`cd` into the repository

run `rails db:create` to create the database
run `rails db:migrate` to run the migration for the transaction object
run `rails db:seed` to populate the database with example data. This is optional, manually entering calls to the add transaction route will work just as well.

run `rails server` and go to http://localhost:3000/transactions to see the index page

It might be the case that you will get an error when connecting to localhost. To fix, run the command `bundle exec rails webpacker:install`. If it tells you there is a conflict, press `a` and enter.


The index page http://localhost:3000/transactions (GET) returns the following:
-a list of all transactions' payer names, points, and timestamps in reverse chronological order, along with options to read, update, or delete a specific transaction.
-a link to a page where you may manually add the payer, points, and timestamp to create a transaction
-a form to spend a number of points
-a list of payers and their total point balances

The route POST http://localhost:3000/transactions creates a transaction from a JSON object. Examples can be manually added below in Postman:

-{ "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z" }
-{ "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
-{ "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
-{ "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
-{ "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" 
 
The route POST http://localhost:3000/spend will spend points according to a JSON object’s point total. Points are spent in chronological order by transaction. Each point deduction creates a transaction object. 

-{ "points": 5000 }

Returns a list of JSON objects indicating payer and points deducted.

[    { "payer": "DANNON", "points": -100 },    { "payer": "UNILEVER", "points": -200 },    { "payer": "MILLER COORS", "points": -4,700 }]

Total point balances for payers are updated accordingly, and returning to the index page reflects this.
