open util/integer
open util/boolean
sig string {}

enum TypeOfViolation {
	DoubleParking,
	ParkInNoParking
}

sig Image {
	imageID: one Int
}{imageID > 0}

sig Report {
	numberID: one Int,
	type: one TypeOfViolation,
	description: one string,
   	images: some Image,
	position: one Position,
	dateTime: one DateTime
}{numberID > 0}

abstract sig User {
	email: one string,
	password: one string,
	reportsUploaded: some Report,
	level: one Level,
	position: one Position
}
sig Citizen extends User {
	stats: StandardStats
}
sig Authority extends User {
	id: one Int,
	stats: CompleteStats
}

sig DateTime {
	day: one Int,
	month: one Int,
	year: one Int,
	minute: one Int,
	second: one Int
	}{day > 0 month > 0 year > 0 minute >= 0 second >= 0}

sig Position {
	latitude: one Int,
	longitude: one Int
}{latitude > 0 longitude > 0}

enum Level {	
	Standard,
	Complete
}

abstract sig Stats {
	publicValues: some Int
}

sig StandardStats extends Stats {}
sig CompleteStats extends Stats {
	sensitiveValues: some Int
}
/*
every fact name is self explanatory
so, no comment on them
*/
fact noUserSameEmail {
	no disj u1, u2 : User | u1.email = u2.email
}

fact noReportSameIdOrSamePosAndDate {
	no disj r1, r2 : Report | (r1.numberID = r2.numberID) or (r1.position = r2.position and r1.dateTime = r2.dateTime)
}

fact noImageSameId {
	no disj i1, i2 : Image | i1.imageID = i2.imageID
}

fact noAuthoritySameId {
	no disj a1, a2 : Authority | a1.id = a2.id
}

fact dateTimeOnlyWithinReport {
	all d1 : DateTime | one r1 : Report | d1 in r1.dateTime
}

fact levelOnlyWithinUser {
	all l1 : Level | one u1 : User | l1 in u1.level
}

fact typeOfViolationOnlyWithinReport {
	all t1 : TypeOfViolation | one r1 : Report | t1 in r1.type
}

fact ImageOnlyWithinReport {
	all i1 : Image | one r1 : Report | i1 in r1.images
}

fact positionOnlyWithinUserOrReport {
	all p1 : Position | some r1 : Report, u1 : User | p1 in r1.position or p1 in u1.position
}

fact differentLocationsHasDifferentParameters {
	no disj p1, p2 : Position | (p1.latitude = p2.latitude and p1.longitude = p2.longitude)
}

fact giveRightLevelsToUsers {
	all a1 : Authority | a1.level = Complete
}

fact giveRightLevelsToUsers2 {
	all c1 : Citizen | c1.level = Standard
}

fact noUserSamePosition {
	all disj u1,u2 : User | u1.position != u2. position
}

fact emailDifferentFromPassword {
	all u1 : User | u1.email != u1.password
}
