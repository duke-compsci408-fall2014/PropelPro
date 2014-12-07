# Health Alert
==============

This is an application to provide patients, doctors, and selected contacts with realtime health notifications. The patient and doctor are able to set an acceptable range of values for any health statistic. For example, a patient may have a range of 160 lbs to 180 lbs for their weight. If a measurement is taken outside of this range, the patient, doctor, and selected contacts will all be notified by call and/or text. (This is decided in the user’s settings.) The purpose of this application is to help patients commit to better health with a support network of doctors and friends.


## Notifications
----------------

Notifications are made via call or text using the Twilio Calling and Texting API. In this repository, we have included a copy of the code, but it is actually hosted in a separate repository on Heroku. The server accepts two GET requests: /notifyWithCall and /notifyWithText. Both requests require several parameters as well: recipientName, patientName, recipientPhoneNumber, statName, statUnit, statValue, statLowerBound, and statUpperBound. The Twilio account we are currently using is a limited free account and will run out of credits after a few hundred notifications.

## Database
----------------

The database that we are using is a MySQL database that is hosted by Duke Co-lab’s Bitnami VM. While we are pulling data from the database that is used by HealthKit, we’re also using our MySQL database to store things like Doctor’s information, patient’s notification preference etc. Our MySQL database contains the schema for Bounds, Doctors, Notifications, Patients, Patients_Doctors, and Stats. Like the notifications, this repository will only contains a copy of the PHP code that is use to get retrieve data from the database. The actual repository will be placed within the Apache2 server within the co-lab Bitnami VM. These fill will generate a JSON file of the information that our IOS app is requesting from the database. 

The PHP code can be found in this repository: https://github.com/wei-zheng-chen/PHPDatabaseCalls.git
Accessing MySQL database: Ask us


