open util/integer
open util/boolean
sig string {}
enum TypeOfViolation {
    DoubleParking,
    ParkInNoParking
}

sig Image {
    imageID: one Int,
	negativeFeedback: one Int
}{imageID > 0}

sig Report {
    numberID: one Int,
    type: one TypeOfViolation,
    description: one string,
    images: some Image,
    position: one Position,
    date: one Date,
	time: one Time,
	fineMark: one Bool,
	negativeFeedback: one Int
}{numberID > 0}

abstract sig User {
    email: one string,
    password: one string,
    reportsUploaded: Report,
    level: one Level,
    position: one Position
}
sig Citizen extends User {

}

sig Authority extends User {
    id: one Int
}

sig Date { }
sig Time { }

sig Position {
    latitude: one Int,
    longitude: one Int
}{latitude > 0 longitude > 0}

sig DailyMap{
	dailyViolation: Report,
	day: one Date
}

enum Level {
    Standard,
    Complete
}

fact noUserSameEmail {
    no disj u1, u2 : User | u1.email = u2.email
}

fact noReportSameIdOrSamePosAndDate {
    no disj r1, r2 : Report | (r1.numberID = r2.numberID) or (r1.position = r2.position and r1.date = r2.date and r1.time = r2.time)
}

fact noImageSameId {
    no disj i1, i2 : Image | i1.imageID = i2.imageID
}

fact noAuthoritySameId {
    no disj a1, a2 : Authority | a1.id = a2.id
}

fact dateOnlyWithinReport {
    all d1 : Date | one r1 : Report | d1 in r1.date
}

fact timeOnlyWithinReport {
    all t1 : Time | one r1 : Report | t1 in r1.time
}

fact levelOnlyWithinUser {
    all l1 : Level | some u1 : User | l1 in u1.level
}

fact typeOfViolationOnlyWithinReport {
    all t1 : TypeOfViolation | some r1 : Report | t1 in r1.type
}

fact reportOnlyWithinReporter {
	all dossier : Report | some user : User | dossier in user.reportsUploaded
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

fact noImageWithMoreThanFiveOrNegativeFeedback{
	all image: Image | image.negativeFeedback < 5 and image.negativeFeedback  > 0
}

fact noReportWithMOreThanFiveOrNegativeFeedback{
	all dossier: Report | dossier.negativeFeedback < 5 and dossier.negativeFeedback > 0
}

fact dailyMapHasOnlyTodayReport{
	all map : DailyMap, dossier : Report | dossier in map.dailyViolation iff dossier.date = map.day
}

fact dossierReportedByExactlyOneUser{
	no disj u1, u2 : User | all violation : Report | (violation in u1.reportsUploaded) and (violation in u2.reportsUploaded)
}

fact noTwoMapWithSameDay{
	no disj m1, m2 : DailyMap | m1.day = m2.day
}
