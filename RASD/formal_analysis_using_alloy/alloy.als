open util/integer
open util/boolean

sig string {}

sig ViolationType{ }

// Every image must have exactly one ID and one feedback counter
sig Image {
    imageID: one Int,
	negativeFeedback: one Int
}{imageID > 0}

// Every report must have exactly one ID, one type, one date, one time,
//one fine mark and one feedback counter, at least one image and at most one description
sig Report {
    numberID: one Int,
    type: one ViolationType,
    description: lone string,
    images: some Image,
    position: one Position,
    date: one Date,
	time: one Time,
	fineMark: one Bool,
	negativeFeedback: one Int
}{numberID > 0}

// Every user must have exactly one email, one password, one level and one position
abstract sig User {
    email: one string,
    password: one string,
    reportsUploaded: set Report,
    level: one Level,
    position: one Position
}

sig Citizen extends User { }

// Every authority must have exactly one ID
sig Authority extends User {
    id: one Int
} {id > 0}

sig Date { }

sig Time { }

// Every position must have exactly one latitude and one longitude
sig Position {
    latitude: one Int,
    longitude: one Int
}{latitude > 0 longitude > 0}

// Every daily map must have exaclty one date
sig DailyMap{
	dailyViolation: set Report,
	day: one Date
}

enum Level {
    Standard,
    Complete
}

// Two users can not be registered with the same email
fact noUserSameEmail {
    no disj u1, u2 : User | u1.email = u2.email
}

// Two reports can not have the same ID
fact noReportSameIdOrSamePosAndDate {
    no disj r1, r2 : Report | r1.numberID = r2.numberID
}

// Two images can not have the same ID
fact noImageSameId {
    no disj i1, i2 : Image | i1.imageID = i2.imageID
}

// Two authority can not have the same Authority ID
fact noAuthoritySameId {
    no disj a1, a2 : Authority | a1.id = a2.id
}

// Every date must be associated with exactly one daily map
fact allDateWithinOneDailyMap {
    all d1 : Date | one dm1: DailyMap | d1 in dm1.day
}

// Every time must be associated with at least one report
fact timeOnlyWithinReport {
    all t1 : Time | some r1 : Report | t1 in r1.time
}

// Every type of violation can exist only within a report
fact violationTypeOnlyWithinReport {
     all t1 : ViolationType | some r1 : Report | t1 in r1.type
}

// Every report must be associated with exaclty one user
fact reportOnlyWithinReporter {
	all dossier : Report | one user : User | dossier in user.reportsUploaded
}

// Every image must be associated to exactly one report
fact ImageOnlyWithinReport {
    all i1 : Image | one r1 : Report | i1 in r1.images
}

// Every position can exist only within a user or a report
fact positionOnlyWithinUserOrReport {
    all p1 : Position | some r1 : Report, u1 : User | p1 in r1.position or p1 in u1.position
}

// Different locations hav a dfferent latitude or longitude
fact differentLocationsHasDifferentParameters {
    no disj p1, p2 : Position | (p1.latitude = p2.latitude and p1.longitude = p2.longitude)
}

// Every authority is associated with a complere autorization level
fact giveRightLevelsToUsers {
    all a1 : Authority | a1.level = Complete
}

// Every citizen is associated with a standard autorization level
fact giveRightLevelsToUsers2 {
    all c1 : Citizen | c1.level = Standard
}

// User's email can not be his password
fact emailDifferentFromPassword {
    all u1 : User | u1.email != u1.password
}

// An image must have more at least 0 and at most 4 negative feedbacks
fact noImageWithMoreThanFiveOrNegativeFeedback{
	all image: Image | image.negativeFeedback < 5 and image.negativeFeedback  >= 0
}

// A report must have at least 0 and at most 4 negative feedback
fact noReportWithMOreThanFiveOrNegativeFeedback{
	all dossier: Report | dossier.negativeFeedback < 5 and dossier.negativeFeedback >= 0
}

// A daily map contains only report with its same date
fact dailyMapHasOnlyTodayReport{
	all map : DailyMap, dossier : Report | dossier in map.dailyViolation
	iff dossier.date = map.day
}

// Every report is reported by exactly one user
fact dossierReportedByExactlyOneUser{
	no disj u1, u2 : User | some violation : Report | (violation in u1.reportsUploaded) and
	(violation in u2.reportsUploaded)
}

// Every daily map is associated to a different date
fact noTwoMapWithSameDay{
	no disj m1, m2 : DailyMap | m1.day = m2.day
}

// Every report must be associated to a daily map
fact everyReportWithinADailyMap{
	all r1: Report | one dm1: DailyMap | r1.date in dm1.day
}

// Every sting can exist only within a description, an email or a password
fact stringOnlyWithinContext{
	all s1: string | some r1: Report, u1: User | s1 in r1.description or s1 in u1.email
	or s1 in u1.password
}

pred world1 {
	#Report = 2
	#Image = 4
	#Citizen = 1
	#Authority = 1
	(some disj i1, i2: Image | some disj r1, r2: Report | i1 in r1.images and i2 in r2.images
	and r1 in Citizen.reportsUploaded and r2 in Authority.reportsUploaded)
}

run world1 for 4 but 1 DailyMap

pred world2 {
	#DailyMap = 2
	#Report = 3
	(some disj r1, r2: Report | some disj m1, m2: DailyMap | r1.date = m1.day and r2.date = m2.day)
}

run world2 for 4

pred world3 { }

run world3 for 5